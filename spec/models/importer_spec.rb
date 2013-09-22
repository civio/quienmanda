require 'spec_helper'

describe Importer do
  context 'when importing a fact' do
    before do
      @husband = create(:public_person, name: 'Adam')
      @relation = create(:relation_type, description: 'is married to')
      @wife = create(:public_person, name: 'Eve')
      @importer = Importer.new
    end

    it 'the result includes a reference to the input fact' do
      fact = create(:fact, source: 'Adam', role: 'is married to', target: 'Eve')
      match = @importer.match( [fact] )
      match.first[:fact].should == fact
    end

    it 'returns matched attributes' do
      fact = create(:fact, source: 'Adam', role: 'is married to', target: 'Eve')
      match = @importer.match( [fact] )
      match.size.should == 1
      match.first.should == { source: @husband, 
                              source_score: 1,
                              relation_type: @relation, 
                              target: @wife, 
                              target_score: 1,
                              fact: fact }
    end

    it 'ignores beginning/trailing spaces when matching entities or relation types' do
      fact = create(:fact, source: 'Adam ', role: ' is married to ', target: ' Eve')
      match = @importer.match( [fact] )
      match.size.should == 1
      match.first.should == { source: @husband, 
                              source_score: 1,
                              relation_type: @relation, 
                              target: @wife, 
                              target_score: 1,
                              fact: fact }
    end

    it 'fuzzy matching requires one exact match word' do
      fact = create(:fact, source: 'Adan', role: 'is married to', target: 'Eva')
      match = @importer.match( [fact], matching_threshold: 0.1 )
      match.size.should == 1
      match.first.should == { source: nil, 
                              source_score: 0,
                              relation_type: @relation, 
                              target: nil, 
                              target_score: 0,
                              fact: fact }
    end

    it 'supports fuzzy matching entities when one word matches exactly' do
      fact = create(:fact, source: 'Adam the-guy', role: 'is married to', target: 'Eve the-girl')
      match = @importer.match( [fact], matching_threshold: 0.1 )
      match.size.should == 1
      match.first.should == { source: @husband, 
                              source_score: 0.5,
                              relation_type: @relation, 
                              target: @wife, 
                              target_score: 0.36363636363636365,
                              fact: fact }
    end

    it 'property names are configurable' do
      custom_importer = Importer.new(source_field: 'Who', role_field: 'What', target_field: 'To whom')
      custom_fact = Fact.new(properties: { 'Who' => 'Adam', 'What' => 'is married to', 'To whom' => 'Eve'})
      match = custom_importer.match([custom_fact])
      match.first.should == { source: @husband, 
                              source_score: 1,
                              relation_type: @relation, 
                              target: @wife, 
                              target_score: 1,
                              fact: custom_fact }
    end
  end

  context 'when using a preprocessor' do
    before do
      @husband = create(:public_person, name: 'Adam')
      @married = create(:relation_type, description: 'is married to')
      @friends = create(:relation_type, description: 'is friends with')
      @wife = create(:public_person, name: 'Eve')
      @importer = Importer.new
    end

    it 'applies the preprocessing before matching' do
      # Add a spellchecker as a preprocessor
      spellchecker = ->(properties) { properties[:role] = "is married to"; properties }
      @importer.preprocessor = spellchecker

      fact = create(:fact, source: 'Adam', role: 'is maried to', target: 'Eve')
      match = @importer.match( [fact] )
      match.first.should == { source: @husband, 
                              source_score: 1,
                              relation_type: @married, 
                              target: @wife, 
                              target_score: 1,
                              fact: fact }
    end

    it 'the preprocessor can delete facts' do
      # Add a filter as a preprocessor, return an empty array to ignore a fact
      filter = ->(properties) { [] }
      @importer.preprocessor = filter

      match = @importer.match( [create(:fact, source: 'Adam', role: 'is married to', target: 'Eve')] )
      match.should == []
    end

    it 'the preprocessor can add facts' do
      # Add a filter as a preprocessor, return nil to ignore a fact
      splitter = ->(properties) do
        another_fact_properties = { source: 'Adam', role: 'is friends with', target: 'Eve' }
        properties[:role] = 'is married to'
        [properties, another_fact_properties]
      end
      @importer.preprocessor = splitter

      fact = create(:fact, source: 'Adam', role: 'is married to / is friends with', target: 'Eve')
      match = @importer.match( [fact] )
      match.should =~ [ { source: @husband, 
                              source_score: 1,
                              relation_type: @married, 
                              target: @wife, 
                              target_score: 1,
                              fact: fact },
                        { source: @husband, 
                              source_score: 1,
                              relation_type: @friends, 
                              target: @wife, 
                              target_score: 1,
                              fact: fact } ]
    end
  end

  context 'after importing a fact' do
    before do
      @that_obama_guy = create(:public_person, name: 'Obama')
      @director_relation = create(:relation_type, description: 'president')
      @that_country = create(:public_organization, name: 'USG')
      @importer = Importer.new
    end

    it 'keeps track of non-matched relation types' do
      @importer.match( [create(:fact, role: 'a role')] )
      @importer.matched_relation_types.size.should == 1
      @importer.matched_relation_types['a role'][:count].should == 1
      @importer.matched_relation_types['a role'][:object].should == nil
    end

    it 'keeps track of matched relation types' do
      @importer.match( [create(:fact, role: 'president')] )
      @importer.matched_relation_types.size.should == 1
      @importer.matched_relation_types['president'][:count].should == 1
      @importer.matched_relation_types['president'][:object].should == @director_relation
    end

    it 'keeps track of non-matched source entities' do
      @importer.match( [create(:fact, source: 'a guy')] )
      @importer.matched_entities.size.should == 2   # Includes target entity
      @importer.matched_entities['a guy'][:count].should == 1
      @importer.matched_entities['a guy'][:object].should == nil
    end

    it 'keeps track of matched source entities' do
      @importer.match( [create(:fact, source: 'Obama')] )
      @importer.matched_entities.size.should == 2   # Includes target entity
      @importer.matched_entities['Obama'][:count].should == 1
      @importer.matched_entities['Obama'][:object].should == @that_obama_guy
    end

    it 'keeps track of non-matched target entities' do
      @importer.match( [create(:fact, target: 'an organization')] )
      @importer.matched_entities.size.should == 2   # Includes source entity
      @importer.matched_entities['an organization'][:count].should == 1
      @importer.matched_entities['an organization'][:object].should == nil
    end

    it 'keeps track of matched target entities' do
      @importer.match( [create(:fact, target: 'USG')] )
      @importer.matched_entities.size.should == 2   # Includes source entity
      @importer.matched_entities['USG'][:count].should == 1
      @importer.matched_entities['USG'][:object].should == @that_country
    end
  end
end
