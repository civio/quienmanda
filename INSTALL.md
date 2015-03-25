### Deploying locally

Ruby 2.0 needed. You can install it using RVM:
 
    $ rvm get stable
    $ rvm install 2.0.0
    
Postgres is used for the database. We use the `hstore` datatypes, so 9.0 is required. If developing in OS X [Postgres.app](http://postgresapp.com) is the easiest way to get Postgres installed. Then create a user `qm` and the database:
 
    $ createuser -s -h localhost qm
    $ createdb -O qm -h localhost qm_development
    $ createdb -O qm -h localhost qm_test

ImageMagick is a dependency of Carrierwave, and is used to manipulate scaled images. You'll need to install it manually:

    $ brew install imagemagick # in OS X
    $ # TODO: add Linux command

Then install and run locally, get a copy of the code, install the dependencies:
 
    $ git clone https://github.com/civio/quienmanda.es.git
    $ cd quienmanda.es
    $ bundle install

We keep "sensitive parameters" in a local file `config/application.yml` outside of version control. Make a copy of `config/application.yml-example` into `config/application.yml`; for a local deployment you don't need to modify the settings.

Set up the database (this will also create some sample data, and a user with email `admin@quienmanda.es` and password `password`):

    $ bundle exec rake db:setup

Run the tests:

    $ bundle exec rake

And then run the application:

    $ bundle exec rails server

### Deploying in Heroku

There is a nice guide [here][1], but basically start by creating the app:
 
    $ heroku apps:create
    $ heroku addons:add memcachier

[1]: https://devcenter.heroku.com/articles/rails4-getting-started

In production uploaded pictures are stored in S3, so you will need to provide your AWS credentials, which we handle safely using the Figaro gem. Edit `config/application.yml` and then, to set the env variables in Heroku, run:

    $ rake figaro:heroku

(Or, if you have multiple Heroku apps in the same folder, do `rake figaro:heroku[myapp]`.)

You can now deploy and start the app:

    $ git push heroku master
    $ heroku run rake db:setup

    $ heroku apps:open

### Deploying wit docker

Docker latest version needed to run this.

How to use docker in Mac: https://docs.docker.com/installation/mac/
How to use docker in Windows: https://docs.docker.com/installation/windows/

Use the script launch-docker-env.sh in the root of the project to launch the enviroment.

This will:

* Build a new image quienmanda-app with Ruby on rails 2.0
* Launch a docker container with postgresql called quienmanda-db
* Then populate the database
* And launch finally a container running the actual app from the code in your computer, called quienmanda-app

Warning: The db container will continue running in the background after we finish the script.
i        Run "docker stop quienmanda-db && docker rm quienmanda-db" to remove it
