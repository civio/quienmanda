require 'spec_helper'

describe CnmvImporter do
  context 'when matching a relation type' do
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

  context 'when matching a person' do
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

  context 'when matching a company' do
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

  context 'when importing relations' do
    before do
      @importer = CnmvImporter.new
      @person = create(:public_person, name: 'Emilio Botín')
      @organization = create(:public_organization, name: 'Banco Santander, S.A.', short_name: 'Banco Santander')
      @relation = create(:relation_type, description: 'presidente/a')
    end

    it 'does not create a relation if the role is unknown' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'propietario',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 0

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == 'Skipping unknown relation type \'propietario\'...'
      end
    end

    it 'creates the missing imported relations if all info available' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == 'Created relation: Emilio Botín -> presidente/a -> Banco Santander'
      end
    end

    it 'does not import the same fact twice' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects
      @importer.create_missing_objects  # Twice

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == "Skipping fact ##{fact.id}, already has relations..."
      end
    end

    it 'imports the relation start date if available' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.',
                                        'Fecha Nombramiento' => '1/11/1989'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'
      fact.relations.first.from.should == Date.new(1989,11,1)
    end

    it 'enriches an existing relation if it exists, instead of duplicating it' do
      # The relation has been created manually before the import
      create(:relation, 
              source: @person, 
              relation_type: @relation, 
              target: @organization,
              via: 'http://www.bancosantander.es')

      # And now we import it, adding extra data (like 'from') to existing object
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.',
                                        'Fecha Nombramiento' => '1/11/1989'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 1
      fact.relations.first.tap do |relation|
        relation.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'
        relation.from.should == Date.new(1989,11,1) # Imported field
        relation.via.should == 'http://www.bancosantander.es' # Manually entered field
      end

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == "Updating relation: Emilio Botín -> presidente/a -> Banco Santander"
      end
    end
  end

  context 'when importing entities' do
    before do
      @importer = CnmvImporter.new
      @person = create(:public_person, name: 'Emilio Botín')
      @organization = create(:public_organization, name: 'Banco Santander, S.A.', short_name: 'Banco Santander')
      @relation = create(:relation_type, description: 'presidente/a')
    end

    it 'warns if source entity is not found' do
      fact = create(:fact, properties: {'Nombre' => 'Random guy',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Random Guy -> presidente/a -> Banco Santander'

      @importer.event_log.tap do |log|
        log.size.should == 2
        log.first[:severity].should == :info
        log.first[:message].should == 'Created person \'Random Guy\''
        log.last[:severity].should == :info
        log.last[:message].should == 'Created relation: Random Guy -> presidente/a -> Banco Santander'
      end
    end

    it 'create target entity if not found' do
      fact = create(:fact, properties: {'Nombre' => 'Emilio Botin',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'A random company'})
      @importer.match( [ fact ] )
      @importer.create_missing_objects

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> A Random Company'

      @importer.event_log.tap do |log|
        log.size.should == 2
        log.first[:severity].should == :info
        log.first[:message].should == 'Created organization \'A Random Company\''
        log.last[:severity].should == :info
        log.last[:message].should == 'Created relation: Emilio Botín -> presidente/a -> A Random Company'
      end
    end
  end

  # context 'when creating entities' do
  #   it 'create target entity if not found' do
  #     CnmvImporter.new.send(:create_entity, {}).should == 42
  #   end
  # end
end