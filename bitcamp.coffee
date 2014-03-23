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
  app.get "/",             indexRoute

  app.get "/login",        indexRoute
  app.get "/conduct",      indexRoute
  app.get "/hackumentary", indexRoute

  
  app.get "/colorwar",     indexRoute
  app.get "/fireside",     indexRoute
  app.get "/faq",          indexRoute
  app.get "/faq/sponsors", indexRoute

  app.get "/register",       indexRoute
  app.get "/register/one",   indexRoute
  app.get "/register/two",   indexRoute
  app.get "/register/three", indexRoute
  app.get "/register/four",  indexRoute

  # 404
  app.get "/404", indexRoute
  app.get "/*", [(req, res, next) ->
    res.status 404
    next() # Let angular figure out the 404 view.
  , indexRoute]


ready.done()
