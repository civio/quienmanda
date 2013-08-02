quienmanda.es
=============

### Install locally

Rails 2.0 needed. You can install it using RVM:
 
    $ rvm get stable
    $ rvm install 2.0.0
    
Postgres is used for the database. If developing in OS X Postgres.app is the easiest way to get Postgres installed. Then create a user `qm` and the database:
 
    $ createuser -s -h localhost qm
    $ createdb -O qm -h localhost qm_development
    $ createdb -O qm -h localhost qm_test
    
Then install and run locally, get a copy of the code, install the dependencies:
 
    $ git clone https://github.com/dcabo/quienmanda.es.git
    $ cd quienmanda.es
    $ bundle install
    
Set up the database (this will also create some sample data, and a user with email `admin@quienmanda.es` and password `password`):

    $ rake db:setup
    
And run…

    $ rails server

### Deploying in Heroku

There is a nice guide [here][1], but basically:
 
    $ heroku apps:create
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku apps:open
    
[1]: https://devcenter.heroku.com/articles/rails4-getting-started

To back up the Heroku database contents, [see][2]:

    $ heroku addons:add pgbackups
    $ heroku pgbackups:capture
    $ heroku pgbackups                          # show backups done
    
Set up a daily auto-backup by enabling the add-on:

    $ heroku addons:add pgbackups:auto-month

[2]: https://devcenter.heroku.com/articles/pgbackups

### Tools used

 * Ruby 2.0
 * Rails 4.0
 * Devise: authentication
 * CanCan: authorization
 * StringEx: friendly URLs
 * RailsAdmin: the admin panel
 * Carrierwave: imageuploads
 * CKEditor: rich-content editor
 