quienmanda.es
=============

[![Build Status](https://travis-ci.org/civio/quienmanda.es.png)](https://travis-ci.org/civio/quienmanda.es)
[![Coverage Status](https://coveralls.io/repos/civio/quienmanda.es/badge.png?branch=master)](https://coveralls.io/r/civio/quienmanda.es?branch=master)
[![Code Climate](https://codeclimate.com/github/civio/quienmanda.es.png)](https://codeclimate.com/github/civio/quienmanda.es)
[![Dependency Status](https://gemnasium.com/civio/quienmanda.es.png)](https://gemnasium.com/civio/quienmanda.es)
[![Stories in Ready](https://badge.waffle.io/civio/quienmanda.es.svg?label=ready&title=Ready)](http://waffle.io/civio/quienmanda.es)

### Install locally

See [INSTALL.md|INSTALL.md] for detailed setup instructions.

### Components used

A brief summary of the main components used in the app:

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
 * [fuzzy_match](https://github.com/seamusabshere/fuzzy_match)

Additionally, when deploying to production, we use rack-cache and Memcachier (in Heroku).
