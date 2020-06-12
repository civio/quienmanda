This API provides the main information available on the Quién Manda website in JSON format.

## Request & Response Examples

Posts

* [GET /posts](#get-posts)
* [GET /posts/[title]](#get-posts-title)

Photos

* [GET /photos](#get-photos)
* [GET /photos/[id]](#get-photos-id)

People & Organizations

* [GET /people](#get-people)
* [GET /people/[name]](#get-people-name)
* [GET /organizations](#get-organizations)
* [GET /organizations/[name]](#get-organizations-name)
* [GET /entities](#get-entities)
* [GET /entities/[name]](#get-entities-name)

Topics

* [GET /topics](#get-topics)
* [GET /topics/[name]](#get-topics-name)

***

### GET /posts

Example (all posts): http://quienmanda.es/posts.json

Example (first page of posts): http://quienmanda.es/posts.json?page=1

### GET /posts/[title]

Example (a post): http://quienmanda.es/posts/nombramientos-fantasma.json

### GET /photos

Example (all photos): http://quienmanda.es/photos.json

Example (first page of photos): http://quienmanda.es/photos.json?page=1

### GET /photos/[id]

Example (a photo): http://quienmanda.es/photos/341.json

### GET /people

Example (all people): http://quienmanda.es/people.json

Example (first page of people): http://quienmanda.es/people.json?page=1

### GET /people/[name]

Example (a person entity): http://quienmanda.es/people/diego-perez-de-los-cobos-orihuel.json

### GET /organizations

Example (all organizations): http://quienmanda.es/organizations.json

Example (first page of organizations): http://quienmanda.es/organizations.json?page=1

### GET /organizations/[name]

Example (a organization entity): http://quienmanda.es/organizations/grupo-municipal-psoe-ayuntamiento-de-vigo.json

### GET /entities

Example (all entities, both people & organizations): http://quienmanda.es/entities.json

### GET /entities/[name]

Example (entity relations): http://quienmanda.es/entities/diego-perez-de-los-cobos-orihuel.json

### GET /topics

Example (all topics): http://quienmanda.es/topics.json

### GET /topics/[name]

Example (a topic): http://quienmanda.es/topics/tv.json

