BlogPosts = require '../../collections/blog_posts.coffee'
BlogPost = require '../../models/blog_post.coffee'
config = require "../../config"

@index = (req, res, next) ->
  posts = new BlogPosts(null, offset: extractOffset(req))
  posts.fetch().then(() ->
    res.render 'index', posts: posts
  )

@single = (req, res, next) ->
  post = new BlogPost(slug: req.params.slug)
  post.fetch().then(() ->
    res.render 'single', post: post
  )

extractOffset = (req) ->
  (req.query.offset && parseInt(req.query.offset)) || 0
