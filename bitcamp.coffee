{app, ready} = require "./lib/server"


# Server Routes
ready.then ->
  controllers  = require "./lib/controllers"
  api          = require "./lib/controllers/api"
  fireside     = require "./lib/controllers/fireside"

  app.get  "/api/bitcamp", api.bitcamp
  app.post "/api/signup",  api.signup

  app.get  "/api/schools", api.schools

  app.get "/fireside/blocks", fireside.blocks


  # Angular Routes
  app.get "/",           controllers.index
  app.get "/partials/*", controllers.partials

  app.get "/fireside", controllers.index

  # 404
  app.get "/*", [(req, res, next) ->
    res.status 404
    next()
    # Let angular figure out the 404 view.
  , controllers.index]

