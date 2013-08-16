class CnmvImporter < Importer
  def initialize()
    super(source_name: 'Nombre', role_name: 'Cargo', target_name: 'Empresa')
  end
end
