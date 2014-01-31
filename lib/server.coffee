path    = require "path"

express = require "express"

q       = require "q"


exports.app    = app    = express()
exports.server = server = require("http").createServer app
exports.io = io = require("socket.io").listen server, log: false

exports.db     = db     = require "mysql-promise"


app.configure "development", ->
  app.use require("connect-livereload")()
  app.use express.errorHandler()
  app.use express.logger "dev"
  app.use express.static path.join __dirname, "../.tmp"
  app.set "views",       path.join __dirname, "../app/views"

app.configure "production", ->
  app.use express.compress()
  app.use express.favicon path.join __dirname, "../public", "favicon.ico"
  app.use express.static  path.join __dirname, "../public"
  app.set "views",        path.join __dirname, "../public/views"

app.configure ->
  app.use express.static path.join __dirname, "../app"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

  db.configure
    host:     'localhost'
    user:     'bitcamp'
    password: process.env.DB_PASSWORD
    database: 'bitcamp'

# Start server
ready = q.defer()

port = process.env.PORT or 8000
server.listen port, ->
  console.log "Express server listening on port %d in %s mode",
    port, app.get("env")
  ready.resolve()

exports.ready = ready.promise

