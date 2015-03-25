#!/bin/bash

#Build app image to update it
docker build -t quienmanda-app .

docker inspect --format="{{ .State.Running }}" quienmanda-db 2> /dev/null
if [ $? -eq 1 ]; then
    #Launch database container if not is already running
    docker run --name quienmanda-db -e POSTGRES_PASSWORD= -d postgres:latest
fi

#Modify config files for dev env
sed -i.bak 's/*default/*docker/g' config/database.yml
rm config/database.yml.bak || /bin/true
cp config/application.yml-example config/application.yml || /bin/true

#Setup database
docker run --link quienmanda-db:postgresql -it -v $(pwd):/usr/src/app -p 3000:3000 quienmanda-app bundle exec rake db:setup

#Launch app contanier linked to the actual codebase
docker run --link quienmanda-db:postgresql -it -v $(pwd):/usr/src/app -p 3000:3000 quienmanda-app bundle exec rails server


