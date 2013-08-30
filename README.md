quienmanda.es
=============

[![Build Status](https://travis-ci.org/dcabo/quienmanda.es.png)](https://travis-ci.org/dcabo/quienmanda.es)
[![Coverage Status](https://coveralls.io/repos/dcabo/quienmanda.es/badge.png?branch=master)](https://coveralls.io/r/dcabo/quienmanda.es?branch=master)
[![Code Climate](https://codeclimate.com/github/dcabo/quienmanda.es.png)](https://codeclimate.com/github/dcabo/quienmanda.es)
[![Dependency Status](https://gemnasium.com/dcabo/quienmanda.es.png)](https://gemnasium.com/dcabo/quienmanda.es)

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
    $ heroku labs:enable user-env-compile 
    $ git push heroku master
    $ heroku run rake db:setup
    $ heroku apps:open
    
The `labs:enable user-env-compile` command is needed because of [ActsAsTaggable issue #192][1b]: deployment fails during asset precompilation otherwise. (I could try [this proposed solution][1c].)

[1]: https://devcenter.heroku.com/articles/rails4-getting-started
[1b]: https://github.com/mbleigh/acts-as-taggable-on/issues/192
[1c]: https://github.com/mbleigh/acts-as-taggable-on/issues/192#issuecomment-23538713

In production uploaded pictures are stored in S3, so you will need to provide your AWS credentials, which we handle safely using the Figaro gem. So, make a copy of `config/application.yml-example` into `config/application.yml` and fill it with your actual details. Then, run `rake figaro:heroku` to set the env variables in Heroku.

To back up the Heroku database contents, [see][2]:

    $ heroku addons:add pgbackups
    $ heroku pgbackups:capture
    $ heroku pgbackups                          # show backups done
    
Set up a daily auto-backup by enabling the add-on:

    $ heroku addons:add pgbackups:auto-month

[2]: https://devcenter.heroku.com/articles/pgbackups

### Tools used

 * Ruby 2.0 / Rails 4.0 / Rspec
 * [Devise](https://github.com/plataformatec/devise): authentication
 * [CanCan](https://github.com/ryanb/cancan): authorization
 * [StringEx](https://github.com/rsl/stringex): friendly URLs
 * [RailsAdmin](https://github.com/sferik/rails_admin): the admin panel
 * [Kaminari](https://github.com/amatsuda/kaminari): pagination
 * [pg_search](https://github.com/casecommons/pg_search): full text search (Postgres)
 * [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) + [Fog](https://github.com/fog/fog): imageuploads
 * [CKEditor](https://github.com/tsechingho/ckeditor-rails): rich-content editor
 * [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on): tags
 * NewRelic: performance monitoring
 
### Transferring database from production to local

Following [Heroku instructions][3]:

    $ heroku pgbackups:capture
    $ curl -o latest.dump `heroku pgbackups:url`
    $ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U qm -d qm_development latest.dump 
 
[3]: https://devcenter.heroku.com/articles/heroku-postgres-import-export