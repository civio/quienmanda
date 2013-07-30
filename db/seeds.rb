# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Entity.create(name: 'Emilio Botín', description: 'El banquero de España')
Entity.create(name: 'Juan Carlos I', description: 'Rey de España')

User.create(:email => 'admin@quienmanda.es', :password => 'password', :password_confirmation => 'password')
