require 'spec_helper'

describe Importer do
  context 'when importing a relation type' do
    before do
      @importer = CnmvImporter.new
    end

    it 'checks male/female variants' do
      @relation = create(:relation_type, description: 'presidente/a')
      match = @importer.match( [ Fact.new(properties: {'Cargo' => 'Presidente'}) ] )
      match.first[:relation_type].should == @relation
    end

    it "ignores trailing 'de'" do
      @relation = create(:relation_type, description: 'presidente/a de')
      match = @importer.match( [ Fact.new(properties: {'Cargo' => 'Presidente'}) ] )
      match.first[:relation_type].should == @relation
    end

    it "ignores trailing vicepresident type" do
      @relation = create(:relation_type, description: 'vicepresidente/a de')
      match = @importer.match( [ Fact.new(properties: {'Cargo' => 'VicePresidente 3º'}) ] )
      match.first[:relation_type].should == @relation
    end

    it 'splits multiple roles' do
      @board_member = create(:relation_type, description: 'consejero/a')
      @president = create(:relation_type, description: 'presidente/a')
      match = @importer.match( [ Fact.new(properties: {'Cargo' => 'Consejero - Presidente'}) ] )
      match.first[:relation_type].should == @board_member
      match.last[:relation_type].should == @president
    end
  end

  context 'when importing a person' do
    before do
      @importer = CnmvImporter.new
    end

    it 'converts incoming data to name-surname format before matching' do
      @person = create(:public_person, name: 'Abel Matutes Juan')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'MATUTES JUAN, ABEL'}) ] )
      match.first[:source].should == @person
    end

    it 'respects commas in company names' do
      @person = create(:public_person, name: 'Holding, S.A.')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'Holding, S.A.'}) ] )
      match.first[:source].should == @person
    end

    it 'checks short name' do
      @person = create(:public_person, name: 'Abel Matutes Juan', short_name: 'Abel Matutes')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'MATUTES , ABEL'}) ] )
      match.first[:source].should == @person
    end
  end
end