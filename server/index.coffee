path    = require "path"

express = require "express"

q       = require "q"


exports.app    = app    = express()
exports.server = server = require("http").createServer app
exports.io     = io     = require("socket.io").listen server, log: false

exports.db     = db     = require "mysql-promise"

exports.email_server    = require("emailjs").server.connect
  user     : "bitcamp_bitcamp"
  password : "b1tcamp"
  host     : "smtp.webfaction.com"
  ssl      : true
  timeout  : 5000
  domain   : "bitca.mp"


app.configure "development", ->
  app.use require("connect-livereload")()
  app.use express.errorHandler()
  app.use express.logger "dev"
  app.use express.static path.join __dirname, "../.tmp"
  app.set "views",       path.join __dirname, "../client"

app.configure "production", ->
  app.use express.compress()
  app.use express.favicon path.join __dirname, "../public", "favicon.ico"
  app.use express.static  path.join __dirname, "../public"
  app.set "views",        path.join __dirname, "../public"

app.configure ->
  app.use "/bower_components", express.static path.join __dirname, "../bower_components"
  app.use express.static path.join __dirname, "../client"
  app.set "view engine", "jade"
  app.use express.json()
  app.use express.urlencoded()
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
  console.log "Listening on port %d in %s mode", port, app.get("env")
  ready.resolve()


exports.ready = ready.promise


exports.indexRoute = (req, res) ->
  res.render "index"


exports.viewsRoute = (req, res) ->
  res.render req.params[0], (err, html) ->
    if err then res.send 404
    else        res.send html
