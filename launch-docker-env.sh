#!/bin/bash
set -e

#Build app image to update it
docker build -t quienmanda-app .

#Launch database container
docker run --name quienmanda-db -e POSTGRES_PASSWORD= -d postgres:latest

#Modify config files for dev env
sed -i 's/*default/*docker/g' config/database.yml
cp config/application.yml-example config/application.yml || /bin/true

#Setup database
docker run --link quienmanda-db:postgresql -it -v $(pwd):/usr/src/app -p 3000:3000 quienmanda-app bundle exec rake db:setup

#Launch app contanier linked to the actual codebase
docker run --link quienmanda-db:postgresql -it -v $(pwd):/usr/src/app -p 3000:3000 quienmanda-app bundle exec rails server


