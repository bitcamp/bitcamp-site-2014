"use strict"


# Module dependencies.
express = require("express")
path    = require("path")


# Express
app = express()

# Configuration
app.configure "development", ->
  app.use require("connect-livereload")()
  app.use express.static(path.join(__dirname, ".tmp"))
  app.use express.static(path.join(__dirname, "app"))
  app.use express.errorHandler()
  app.set "views", __dirname + "/app/views"

app.configure "production", ->
  app.use(express.compress())
  app.use express.favicon(path.join(__dirname, "public", "favicon.ico"))
  app.use express.static(path.join(__dirname, "public"))
  app.set "views", __dirname + "/public/views"

app.configure ->
  app.set "view engine", "jade"
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router # Router needs to be last


# Controllers
api         = require("./lib/controllers/api")
controllers = require("./lib/controllers")

# Server Routes
app.get  "/api/bitcamp", api.bitcamp
app.post "/api/signup",  api.signup

app.get  "/api/schools", api.schools

app.get "/api/fireside/blocks", api.fireside.blocks

# Angular Routes
app.get "/",             controllers.index
app.get "/partials/*",   controllers.partials

app.get "/fireside", controllers.index

# 404
app.get "/*", [(req, res, next) ->
  res.status 404
  next()
  # Let angular figure out the 404 view.
, controllers.index]


# Start server
port = process.env.PORT or 8000
app.listen port, ->
  console.log "Express server listening on port %d in %s mode",
    port, app.get("env")
