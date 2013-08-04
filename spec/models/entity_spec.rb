require 'spec_helper'

describe Entity do
  context "when accessing relations" do
    before do
      @public_person = create(:public_person, name: "Big shot")
      @holding_company = create(:public_organization, name: "Holding company")
      @child_company = create(:public_organization, name: "Child company")
      @offshore_vehicle = create(:private_organization, name: "Secret offshore company")

      create(:relation, source: @public_person, target: @holding_company, published: true )
      create(:relation, source: @holding_company, target: @child_company, published: true )
      create(:relation, source: @public_person, target: @offshore_vehicle, published: false )
    end

    it "returns all relations the entity is the source of" do
      relations = @holding_company.relations_as_source
      relations.size.should == 1
      relations.first.target.name.should == "Child company"
    end

    it "returns all relations the entity is the target of" do
      relations = @holding_company.relations_as_target
      relations.size.should == 1
      relations.first.source.name.should == "Big shot"
    end

    it "returns all relations the entity is involved in" do
      relations = @holding_company.relations
      relations.size.should == 2
      relations.first.source.name.should == "Big shot"
      relations.last.target.name.should == "Child company"
    end

    it "can filter the returning results as needed" do
      relations = @public_person.relations.published
      relations.size.should == 1
      relations.first.target.name.should == "Holding company"
    end
  end
end
