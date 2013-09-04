require 'spec_helper'

describe Fact do
  it "asking for unprocessed facts returns only the facts without relations" do
    processed = create(:fact)
    unprocessed = create(:fact)

    processed.relations << create(:relation, 
                                  source: create(:public_person), 
                                  target: create(:private_person))

    Fact.unprocessed_facts.tap do |unprocessed_facts|
      unprocessed_facts.size.should == 1
      unprocessed_facts.first.should == unprocessed
    end
  end

  it "unprocessed facts can be filtered by importer" do
    processed = create(:fact)
    unprocessed_csv = create(:fact, importer: 'CSV')
    unprocessed_other = create(:fact)

    processed.relations << create(:relation, 
                                  source: create(:public_person), 
                                  target: create(:private_person))

    Fact.unprocessed_facts.importer('CSV').tap do |unprocessed_facts|
      unprocessed_facts.size.should == 1
      unprocessed_facts.first.should == unprocessed_csv
    end
  end
end
