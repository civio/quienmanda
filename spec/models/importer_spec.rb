require 'spec_helper'

describe Importer do
  context 'after importing a fact' do
    before do
      @that_obama_guy = create(:public_person, name: 'Obama')
      @director_relation = create(:relation_type, description: 'president')
      @that_country = create(:public_organization, name: 'USG')
      @importer = Importer.new
    end

    it 'keeps track of non-matched relation types' do
      @importer.match( create(:fact, role: 'a role') )
      @importer.relation_types.size.should == 1
      @importer.relation_types['a role'][:count].should == 1
      @importer.relation_types['a role'][:relation_type].should == nil
    end

    it 'keeps track of matched relation types' do
      @importer.match( create(:fact, role: 'president') )
      @importer.relation_types.size.should == 1
      @importer.relation_types['president'][:count].should == 1
      @importer.relation_types['president'][:relation_type].should == @director_relation
    end

    it 'keeps track of non-matched source entities' do
      @importer.match( create(:fact, source: 'a guy') )
      @importer.entities.size.should == 2   # Includes target entity
      @importer.entities['a guy'][:count].should == 1
      @importer.entities['a guy'][:entity].should == nil
    end

    it 'keeps track of matched source entities' do
      @importer.match( create(:fact, source: 'Obama') )
      @importer.entities.size.should == 2   # Includes target entity
      @importer.entities['Obama'][:count].should == 1
      @importer.entities['Obama'][:relation_type].should == @that_obama_guy
    end

    it 'keeps track of non-matched target entities' do
      @importer.match( create(:fact, target: 'an organization') )
      @importer.entities.size.should == 2   # Includes source entity
      @importer.entities['an organization'][:count].should == 1
      @importer.entities['an organization'][:entity].should == nil
    end

    it 'keeps track of matched target entities' do
      @importer.match( create(:fact, target: 'USG') )
      @importer.entities.size.should == 2   # Includes source entity
      @importer.entities['USG'][:count].should == 1
      @importer.entities['USG'][:relation_type].should == @that_country
    end
  end
end
