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
 * [PaperTrail](https://github.com/airblade/paper_trail): version control
 * [CKEditor](https://github.com/tsechingho/ckeditor-rails): rich-content editor
 * [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on): tags
 * NewRelic: performance monitoring
 * [Shortcode](https://github.com/carnesmedia/shortcodes)
 
### Transferring database from production to local

Following [Heroku instructions][3]:

    $ heroku pgbackups:capture
    $ curl -o latest.dump `heroku pgbackups:url`
    $ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U qm -d qm_development latest.dump 
 
[3]: https://devcenter.heroku.com/articles/heroku-postgres-import-export

### Importing data via CSV uploads

Entities and relations among them can be created automatically by uploading Facts via a CSV file. The file to import must:

 * Have a title row. The values of the fields in this row will be used as column names.
 * Contain at least three columns: 'source', 'role' and 'target'. Additional columns will be imported as additional attributes of the Fact.

NOTE: If generating the CSV file from Excel, be careful with the character encoding. The application will try to guess the encoding of the uploaded file (using Charlock Holmes), but it may not always guess right and misread some accented characters. If you don't know how to set the encoding manually to UTF8 (using for example TextMate), try at least to save in Excel as "Windows Comma Separated Values", it seems to make detection by Charlock Holmes more accurate.

The process has two steps: the upload will create a number of Fact objects, containing all the source data. Once the data is in the database, Facts are 'processed' to match them against existing entities (or new ones that will be created if needed).

Steps are as follows:

1. Go to the Import page vía the Admin panel, and select the CSV file to import.
1. Clicking 'Upload' will parse the CSV file and create a Fact in the database for each row in the source file. The uploader checks a Fact does not already exist before creating (using source-role-target as the key), so uploading one file again and again is safe, i.e. the uploading is idempotent. (Note: existing Facts are not modified, so changes in fields outside the primary key will be ignored.)
1. After a successful upload, a results summary page will be shown, listing the uploaded facts, and showing which ones were already known and were thus ignored.
1. Once the file is uploaded, facts need to be processed: this can be done either from the main Import page, or from the upload results page. New entities and relations are created at this point (after the dry run results are reviewed and approved by the user).
