require 'spec_helper'

describe CnmvImporter do
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

    it 'ignores missing accents in the imported data' do
      @person = create(:public_person, name: 'Emilio Botín')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'BOTIN , EMILIO'}) ] )
      match.first[:source].should == @person
    end

    it 'ignores missing accents in the existing data' do
      @person = create(:public_person, name: 'Emilio Botin')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'BOTÍN , EMILIO'}) ] )
      match.first[:source].should == @person
    end

    it 'matches Ñ correctly' do
      @person = create(:public_person, name: 'Supermaño')
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'SUPERMAÑO'}) ] )
      match.first[:source].should == @person
    end

    it 'matches funny apostrophes' do
      @person = create(:public_person, name: "Ana Patricia Botín-Sanz Sautola O'Shea")
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'BOTIN-SANZ SAUTOLA O´SHEA, ANA PATRICIA'}) ] )
      match.first[:source].should == @person
    end

    it 'preprocesses the name on splitted facts' do
      @person = create(:public_person, name: 'Emilio Botín')
      # 'Presidente-Jefe' will be split by the preprocessor in two roles
      match = @importer.match( [ Fact.new(properties: {'Nombre' => 'BOTIN , EMILIO', 'Cargo' => 'presidente-jefe'}) ] )
      match.size.should == 2
      match.first[:source].should == @person
      match.last[:source].should == @person
    end
  end

  context 'when importing a company' do
    before do
      @importer = CnmvImporter.new
    end

    it 'checks name' do
      @organization = create(:public_organization, name: 'Banco Santander, S.A.')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'BANCO SANTANDER, S.A.'}) ] )
      match.first[:target].should == @organization
    end

    it 'checks short name' do
      @organization = create(:public_organization, name: 'Banco Santander, S.A.', short_name: 'Banco Santander')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'BANCO SANTANDER'}) ] )
      match.first[:target].should == @organization
    end

    it 'ignores missing accents in the imported data' do
      @organization = create(:public_organization, name: 'Telefónica, S.A.')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'TELEFONICA, S.A.'}) ] )
      match.first[:target].should == @organization
    end

    it 'ignores missing accents in the existing data' do
      @organization = create(:public_organization, name: 'Telefonica, S.A.')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'Telefónica, S.A.'}) ] )
      match.first[:target].should == @organization
    end

    it 'matches Ñ correctly' do
      @organization = create(:public_organization, name: 'Banco de España')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'BANCO DE ESPAÑA'}) ] )
      match.first[:target].should == @organization
    end
  end
end