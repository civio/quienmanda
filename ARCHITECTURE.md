Old notes from when QM got started:

### Rails and Ruby versions

Some notes on how I'm making certain architectural-ish decisions (expanding on an [email to the 'civio-dev' mailing list][1]):

 * Heroku and Postgres were definitely in, no question about it. That stays.

 * Rails 4 has some interesting things, like support for Postgres native types: the key-value store `hstore` - [built by Heroku][2] - looks nice, and useful!, and is well liked [even in YC][3]; and it's [supported by Heroku in dev][4], and also in my local Postgres.app (version 9.2.4 > 9.1). I can see myself using `hstore` beyond the basic model attributes (I even thought of using MongoDB last summer, when I first thought about the QM backend, precisely for this flexibility), but still, Rails 4 felt too inmature: the RC1 was released [in May][5], and critical gems like Devise had been compatible [only a couple of days ago][6]. Well, it was May when I took those notes, and now it's almost August, so Rails 4 feels like the right choice. (I hope I won't regret it.)

 * The Ruby version was easier: Ruby 2.0 is [the default in Heroku][7], recommended by Rails also, and it's probably [not a big deal][8] anyway.

 * Next was user registration and authentication, something that (oh, progress!) is now completely commoditized, and I'm happy for that. [Devise][9] is clearly the [most popular option][10], together with [OmniAuth][11] for multi-log-in-provider support (i.e. log in using Facebook or Twitter or whatever). They [work well together][12], so it's all good.

 * After authentication comes authorisation, and Cancan is by far [the 'de-facto' standard][13]. 

 * While researching all this, I found 'starter kits' and 'app templates'. [Suspenders][14] is created and supported by the smart people of Thoughtbot, and seems focused on laying a good testing and dev environment, but there were too many little pieces I didn't know and wasn't sure I needed. Then there're the [RailsApps templates][15], and one specifically for Devise+CanCan integration, which felt like a good idea initially. But I decided to do it myself to get a better understanding of how it all works, and it was the right decision: it wasn't that difficult once I understood what the different components were for.

[1]: https://groups.google.com/forum/?hl=es#!topic/civio-dev/k9if-K7Hug8
[2]:  https://postgres.heroku.com/blog/past/2012/3/14/introducing_keyvalue_data_storage_in_heroku_postgres/
[3]: https://news.ycombinator.com/item?id=3340340
[4]: https://postgres.heroku.com/blog/past/2012/7/25/release_of_new_plans_on_august_1st/
[5]: http://weblog.rubyonrails.org/2013/5/1/Rails-4-0-release-candidate-1/
[6]: http://blog.plataformatec.com.br/2013/05/devise-and-rails-4/
[7]: https://blog.heroku.com/archives/2013/6/17/ruby-2-default-new-aps 
[8]: http://stackoverflow.com/questions/15799687/what-are-the-major-differences-between-ruby-1-9-3-and-ruby-2-0-0
[9]: https://github.com/plataformatec/devise
[10]: https://www.ruby-toolbox.com/categories/rails_authentication
[11]: https://github.com/intridea/omniauth
[12]: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
[13]: https://www.ruby-toolbox.com/categories/rails_authorization
[14]: https://github.com/thoughtbot/suspenders
[15]: https://github.com/RailsApps/rails3-bootstrap-devise-cancan

### Image uploads

On image uploads, Paperclip seems to be the traditional choice and is [well documented][16]. Dragonfly seems too weird and maybe unmaintained, so it's [between Paperclip and CarrierWave][17].

Seems like CarrierWave overtook Paperclip at some point (S3 support for example) but it then came back, and Paperclip has S3 support too. The latest in Stack Overflow suggests [both are fine][18], with Paperclip slightly more popular, but [falling in popularity][19]. All in all Carrierwave feels more agile, more modern, and I like little details like - for example - the fact that they use a smaller alternative to ImageMagick. Polish as heuristic.

Uploads to Heroku bring a number of issues, so I need to think about overall architecture (although not from day one probably, since we won't have many uploads). [This answer][20] explains it very well (and it's from the same guy [who prefers CarrierWave][18]).

[16]: https://devcenter.heroku.com/articles/paperclip-s3
[17]: http://stackoverflow.com/questions/14028017/heading-into-2013-should-i-go-with-dragonfly-or-paperclip-or-carrierwave?lq=1
[18]: http://stackoverflow.com/questions/16447366/need-assistance-choosing-a-image-management-gem/16463086#16463086
[19]: https://www.ruby-toolbox.com/categories/rails_file_uploads
[20]: http://stackoverflow.com/questions/16307493/best-ruby-on-rails-architecture-for-image-heavy-app/16341162

### PopIt

I seriously considered it for a while. I even made a now very obscure list of needed extensions or improvements:

<ul>
<li>Use links or positions to store relations?</li>
<li>Allow person on right side of position?  Or create new category?</li>
<li>Add tags like in Alaveteli to people and orgs (including value tags CIF:123). Great extension mechanism, almost FluidInfo</li>
<li>Add Source in position</li>
<li>Add Dates in positions</li>
<li>Add media items to person (could use links)</li>
<li>Edit in place</li>
<li>How to merge two people?</li>
<li>Edit via API</li>
<li>Limit relations to limited set?</li>
</ul>

<p>I thought it would be the quickest option, and made sense strategically, building on top of a potentially popular component. But I didn't like the idea on being dependent on it when there wasn't a clear strategy: proof of that, they created <a href="https://github.com/mysociety/popit-django" rel="nofollow">popit-django</a>, a few months later. A bizarre architectural decision, and a mix-match of technologies: node.js, Mongo, Django, Postgres.</p>

### Dependencies

A brief summary of the main components used in the app:

 * Ruby 2.0 / Rails 4.0 / Rspec
 * [Devise](https://github.com/plataformatec/devise): authentication
 * [CanCan](https://github.com/ryanb/cancan): authorization
 * [StringEx](https://github.com/rsl/stringex): friendly URLs
 * [RailsAdmin](https://github.com/sferik/rails_admin): admin panel
 * [Kaminari](https://github.com/amatsuda/kaminari): pagination
 * [pg_search](https://github.com/casecommons/pg_search): full text search (Postgres)
 * [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) + [Fog](https://github.com/fog/fog): image uploads
 * [PaperTrail](https://github.com/airblade/paper_trail): model version control
 * [CKEditor](https://github.com/tsechingho/ckeditor-rails): rich-content editor
 * [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on): tags
 * NewRelic: performance monitoring
 * [Shortcode](https://github.com/carnesmedia/shortcodes): Wordpress-like shortcodes in posts
 * [fuzzy_match](https://github.com/seamusabshere/fuzzy_match): fuzzy matching on CVS imports
 * rack-cache
