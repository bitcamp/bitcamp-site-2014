{ready, app, indexRoute, viewsRoute} = require "./server"


ready.then ->
  main     = require "./server/main"
  fireside = require "./server/fireside"

  # API Routes
  app.get  "/api/bitcamp", main.bitcamp
  app.post "/api/signup",  main.signup
  app.get  "/api/schools", main.schools

  app.get  "/api/fireside/blocks", fireside.blocks

  # Angular Routes
  app.get "/",         indexRoute
  app.get "/fireside", indexRoute


  # 404
  app.get "/*", [(req, res, next) ->
    res.status 404
    next() # Let angular figure out the 404 view.
  , controllers.index]


ready.done()
