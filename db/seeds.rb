# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

emilio_botin = Entity.create( name: 'Emilio Botín', 
                              description: 'El banquero de España', 
                              person: true, 
                              priority: :high,
                              published: false)

rey_juan_carlos = Entity.create(name: 'Juan Carlos I', 
                                description: 'Rey de España', 
                                person: true, 
                                priority: :high,
                                published: true)

bilderberg = Entity.create( name: 'Grupo Bilderberg', 
                            person: false, 
                            priority: :low,
                            published: false)

banco_santander = Entity.create(name: 'Banco Santander', 
                                person: false, 
                                priority: :high,
                                published: true)

Relation.create(source: emilio_botin,
                target: banco_santander,
                published: true,
                relation: 'president of',
                at: "2013-08-04")

admin = User.create(name: 'Admin', 
                    email: 'admin@quienmanda.es', 
                    password: 'password', 
                    password_confirmation: 'password',
                    admin: true)

user = User.create( name: 'A user', 
                    email: 'user@example.com', 
                    password: 'password', 
                    password_confirmation: 'password',
                    admin: false)

Post.create(title: 'Caso Urdangarín', 
            content: 'Blah blah', 
            author: admin, 
            published: true)

Post.create(title: 'La próxima gran historia', 
            content: 'Caliente caliente', 
            author: admin, 
            published: false)

# Add photo seeds
photo = Photo.create!(title: 'Marichalar de compras', copyright: 'Desconocido', published: true)
photo.file.store!(File.open(File.join(Rails.root, 'db', 'seed_files', 'Marichalar.jpeg')))
photo.save!