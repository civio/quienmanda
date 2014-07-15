# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

emilio_botin = Entity.create!( name: 'Emilio Botín', 
                              description: 'El banquero de España', 
                              person: true, 
                              priority: '1',
                              published: true)

rey_juan_carlos = Entity.create!(name: 'Juan Carlos I', 
                                description: 'Rey de España', 
                                person: true, 
                                priority: '1',
                                published: false)

bilderberg = Entity.create!( name: 'Grupo Bilderberg', 
                            person: false, 
                            priority: '3',
                            published: false)

banco_santander = Entity.create!(name: 'Banco Santander', 
                                person: false, 
                                priority: '1',
                                published: true)

father_of = RelationType.create!(description: 'father of')
owner_of = RelationType.create!(description: 'owner of')
president_of = RelationType.create!(description: 'president of')
member_of = RelationType.create!(description: 'member of')

Relation.create!(source: emilio_botin,
                target: banco_santander,
                published: true,
                relation_type: president_of,
                at: "2013-08-04")

Relation.create!(source: emilio_botin,
                target: bilderberg,
                published: false,
                relation_type: member_of,
                at: "2013-08-04")

admin = User.create!(name: 'Admin', 
                    email: 'admin@quienmanda.es', 
                    password: 'password', 
                    password_confirmation: 'password',
                    admin: true)

user = User.create!( name: 'A user', 
                    email: 'user@example.com', 
                    password: 'password', 
                    password_confirmation: 'password',
                    admin: false)

Post.create!(title: 'Otra historia de corrupción', 
            content: 'Blah blah blah', 
            author: admin, 
            published: true,
            featured: false,
            published_at: '2014-07-01')

Post.create!(title: 'La próxima gran historia', 
            content: 'Caliente caliente', 
            author: admin, 
            published: false,
            published_at: '2014-07-02')

# Add photo seeds
photo_marichalar = Photo.create!(footer: 'Marichalar de compras', copyright: 'Desconocido', published: true)
photo_marichalar.file.store!(File.open(File.join(Rails.root, 'db', 'seed_files', 'Marichalar.jpeg')))
photo_marichalar.save!

# Create a featured article with photo
photo_montoro = Photo.create!(footer: 'Cristóbal Montoro, ministro de Hacienda y Administraciones Públicas', copyright: 'Flickr', published: true)
photo_montoro.file.store!(File.open(File.join(Rails.root, 'db', 'seed_files', 'Montoro.jpeg')))
photo_montoro.save!

Post.create!(title: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fermentum.',
            content: 'Quisque porta semper semper.',
            author: admin,
            published: true,
            published_at: '2014-07-14',
            photo: photo_montoro,
            featured: true)
