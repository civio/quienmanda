quienmanda.es
=============

[![Build Status](https://travis-ci.org/civio/quienmanda.es.png)](https://travis-ci.org/civio/quienmanda.es)
[![Coverage Status](https://coveralls.io/repos/civio/quienmanda.es/badge.png?branch=master)](https://coveralls.io/r/civio/quienmanda.es?branch=master)
[![Code Climate](https://codeclimate.com/github/civio/quienmanda.es.png)](https://codeclimate.com/github/civio/quienmanda.es)
[![Dependency Status](https://gemnasium.com/civio/quienmanda.es.png)](https://gemnasium.com/civio/quienmanda.es)
[![Stories in Ready](https://badge.waffle.io/civio/quienmanda.es.svg?label=ready&title=Ready)](http://waffle.io/civio/quienmanda.es)

Quién Manda is a map of power relations in Spain, combining network visualizations, investigative journalism articles and annotated photos. The code is stable and has been [live](https://quienmanda.es) since October 2013, but some important features are still missing:

 * Embeddable content: sharing annotated photos, network charts and entity profiles in other sites.
 
 * Richer network visualization: different relation/node types, improved look and feel and UX...
 
 * Chart editor: create your own shareable custom graph, with selected nodes and relations.
 
 * REST API: read API giving access to all information in the database.

 * User generated content: voting, crowdsourced data and photo collection, and moderation features.

 * Data: automated bulk data import/updates from official sources.

### Currently working on...

We're testing a [Waffle.io board](https://waffle.io/civio/quienmanda.es) to show which issues we're working on at the moment: we select a coherent set of issues from Backlog and move them into the 'Next milestone' column; once all the issues move to the Done column we go back to the Backlog and repeat the process. We aim to have a series of meaningful milestones (or iterations) forming a sensible high-level roadmap (but if this doesn't work we'll try something else).

We try to write issues that can be understood by newcomers, but this is not always easy, so if you don't understand something please ask. We've also started tagging the issues along functional areas.

### Collaborate

We plan to have regular hack meetings (in Madrid, potentially also online) over 2015 in order to help people get started with the code. The idea is to meet for a few hours, scrape some data, fix some existing issues and/or hack some new feature (like embeddable content, a network graph editor or improving the network visualization). This will be discussed in the [civio-dev mailing list](https://groups.google.com/forum/#!forum/civio-dev).

### Setting it up

See [INSTALL.md](INSTALL.md) for detailed setup instructions.

### Using production content in your local environment

You can develop locally using some fake content created by `rake db:seed`. But it may be useful to work on a copy of the production database, with full-length articles and a fully-populated relation database. We're now looking into what's the best way of exporting the whole production database and making it available for download. 

Two open questions: 
 * how can we edit the database dump to remove user account data? and,
 * how do we handle images, which are stored in S3 in production?
