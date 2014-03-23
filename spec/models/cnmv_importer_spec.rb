require 'spec_helper'

# Some of the tests below are duplicated in the CSVImporter parent class spec 
# (the CNMV importer came first, the CSV one later). I could remove some of the 
# duplicated tests below, but I guess additional tests won't hurt.
describe CnmvImporter do
  context 'when matching a relation type' do
    before do
      @importer = CnmvImporter.new
    end

    it 'ignores accents' do
      @relation = create(:relation_type, description: 'Administrador Único')
      match = @importer.match( [ Fact.new(properties: {'Cargo' => 'ADMINISTRADOR UNICO'}) ] )
      match.first[:relation_type].should == @relation
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

    it "ignores trailing 'de' without female variants" do
      @relation = create(:relation_type, description: 'presidente de')
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

    # Clumsy CNMV
    it 'adds the missing trailing dot at end of company names if needed' do
      @organization = create(:public_organization, name: 'Bankia, S.A.')
      match = @importer.match( [ Fact.new(properties: {'Empresa' => 'BANKIA, S.A'}) ] )
      match.first[:target].should == @organization
    end
  end

  context 'when importing relations on existing entities' do
    before do
      @importer = CnmvImporter.new
      @person = create(:public_person, name: 'Emilio Botín')
      @organization = create(:public_organization, name: 'Banco Santander, S.A.', short_name: 'Banco Santander')
      @relation = create(:relation_type, description: 'presidente/a')
      @another_relation = create(:relation_type, description: 'accionista')
    end

    it 'does not create a relation if the role is unknown' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'propietario',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      fact.relations.size.should == 0
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == 'Skipping fact, unknown relation type \'propietario\'...'
      end
    end

    it 'does not create a relation if the source entity is unknown' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      fact.relations.size.should == 0
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == 'Skipping fact, unknown source entity \'EMILIO\'...'
      end
    end

    it 'does not create a relation if the target entity is unknown' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'Un banco'})
      @importer.match( [ fact ] )
      fact.relations.size.should == 0
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == 'Skipping fact, unknown target entity \'Un banco\'...'
      end
    end

    it 'creates the missing imported relations if all info available' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )

      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == 'Created relation: Emilio Botín -> presidente/a -> Banco Santander'
      end
    end

    it 'does not creates any relation if it is a dry run, but there is an event log' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ], dry_run: true )

      fact.reload
      fact.relations.size.should == 0 # Nothing is done

      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == 'Created relation: Emilio Botín -> presidente/a -> Banco Santander'
      end
    end

    it 'does not duplicate relations if the same fact is imported twice' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )
      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == "Created relation: Emilio Botín -> presidente/a -> Banco Santander"
      end

      # Note: I used to check in the code that the fact hadn't been imported by checking 
      # whether it had already associated relations, and returning a warning if so. 
      # That filtering belongs in the controller. But most importantly, since a preprocessor 
      # can "split" a fact and produce multiple relations, it does happen that we add relations 
      # to facts which already have associations.
      @importer.match( [ fact ] ) # Again...
      fact.relations.size.should == 1
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :info
        log.first[:message].should == "Updating relation: Emilio Botín -> presidente/a -> Banco Santander"
      end
    end

    it 'creates multiple relations if the preprocessor splits the fact in multiple pieces' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente-accionista',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )

      fact.relations.size.should == 2
      fact.relations.first.to_s.should == 'Emilio Botín -> presidente/a -> Banco Santander'
      fact.relations.last.to_s.should == 'Emilio Botín -> accionista -> Banco Santander'

      @importer.event_log.tap do |log|
        log.size.should == 2
        log.first[:severity].should == :info
        log.first[:message].should == "Created relation: Emilio Botín -> presidente/a -> Banco Santander"
        log.last[:severity].should == :info
        log.last[:message].should == "Created relation: Emilio Botín -> accionista -> Banco Santander"
      end
    end

    it 'imports the relation start date if available' do
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.',
                                        'Fecha Nombramiento' => '1/11/1989'})
      @importer.match( [ fact ] )

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
              via: 'http://www.bancosantander.es',
              published: true)

      # And now we import it, adding extra data (like 'from') to existing object
      fact = create(:fact, properties: {'Nombre' => 'EMILIO BOTIN',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.',
                                        'Fecha Nombramiento' => '1/11/1989'})
      @importer.match( [ fact ] )

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

  context 'when importing relations and creating missing entities' do
    before do
      @importer = CnmvImporter.new(create_missing_entities: true)
      @person = create(:public_person, name: 'Emilio Botín')
      @organization = create(:public_organization, name: 'Banco Santander, S.A.', short_name: 'Banco Santander')
      @relation = create(:relation_type, description: 'presidente/a')
    end

    it 'create source entity if not found' do
      fact = create(:fact, properties: {'Nombre' => 'Random guy',
                                        'Cargo' => 'presidente',
                                        'Empresa' => 'BANCO SANTANDER, S.A.'})
      @importer.match( [ fact ] )

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

  context 'when creating entities' do
    before do
      @importer = CnmvImporter.new
      @importer.match([])  # Call match to set up event log
    end

    # Convenience method to call private :create_entity
    def create_entity(attributes); @importer.send(:create_entity, attributes); end

    it 'create entity as specified' do
      entity = create_entity({name: 'foobar', person: true, priority: '1', needs_work: false, published: false})
      entity.name.should == 'Foobar'
      entity.person.should == true
      entity.priority.should == Entity::PRIORITY_HIGH
      entity.needs_work.should == false
      entity.published.should == false
    end

    it 'guess entity type if not specified, and use defaults in other fields' do
      entity = create_entity({name: 'foobar'})
      entity.name.should == 'Foobar'
      entity.person.should == true
      entity.priority.should == Entity::PRIORITY_MEDIUM
      entity.needs_work.should == true
      entity.published.should == true
    end

    it 'guess person/organization type based on name' do
      @importer.is_a_person('foobar').should == true
      @importer.is_a_person('Banco Santander, s.a.').should == false
      @importer.is_a_person('PYME, S.l.').should == false
      @importer.is_a_person('EADS, n.v.').should == false
    end

    it 'creates a cleaner short name for typical company names' do
      entity = create_entity({name: 'Inditex, S.A.'})
      entity.name.should == 'Inditex, S.A.'
      entity.short_name.should == 'Inditex'
    end

    # This happens once in CNMV data (La Seda de Barcelona)
    it 'skips and alerts if name is blank' do
      entity = create_entity({name: ''})
      @importer.event_log.tap do |log|
        log.size.should == 1
        log.first[:severity].should == :warning
        log.first[:message].should == 'Skipping entity with blank name...'
      end
    end

    # Note: having entities in the database with ´ will break future imports,
    # because PostgreSQL lets them through unaccent() but Stringex.to_ascii
    # converts them to single quotes. Hence they need to be single quotes in DB.
    it 'replaces annoying apostrophes with simple quotes' do
      entity = create_entity({name: 'COMPANYIA D´AIGÜES DE SABADELL, S.A.'})
      entity.name.should == 'Companyia D\'Aigües De Sabadell, S.A.'
    end
  end
end