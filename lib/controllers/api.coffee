db      = require "mysql-promise"
{check} = require "validator"
q       = require "q"


io = require("socket.io").listen 8001, {
  log: false
}

io.sockets.on "connection", (socket) ->

  blocksInterval = setInterval ->
    refreshBlocks()
    socket.emit 'fireside/blocks', blocks
  , 3000

  socket.on 'disconnect', ->
    clearInterval blocksInterval


randomN = (min, max) ->
  Math.random * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

blocks = []

randomizedBlocks = (max, n) ->
  fireside_blocks = ({on: false, i: i} for i in [1..max])
  ns = []
  for i in [0...n] when i not in ns
    ns.push randomInt 0, fireside_blocks.length-1
  ns.map (n) -> fireside_blocks[n].on = true
  fireside_blocks

refreshBlocks = ->
  db.query('SELECT count(1) as count FROM signup')
    .spread (rows) ->
      rows[0].count
    .then (count) ->
      randomizedBlocks 3136, count
    .fail (err) ->
      console.log err.message
    .done (bs) ->
      blocks = bs


db.configure
  host:     'localhost'
  user:     'bitcamp'
  password: process.env.DB_PASSWORD
  database: 'bitcamp'


exports.bitcamp = (req, res) ->
  res.json
    bitcamp: true

exports.signup = (req, res) ->
  q(req.body).then ({email}) ->
    email if check(email).isEmail()
  .then (email) ->
    db.query("SELECT email FROM signup WHERE email=?", email)
  .spread (rows) ->
    if rows.length is 0
      db.query('INSERT INTO signup SET ?', req.body)
    else true
  .fail (err) ->
    console.log err.message
    res.json 500, msg: "500"
  .done ->
    res.json 200, msg: "200"


exports.schools = (req, res) ->
  res.json require('../util/schools')

exports.fireside =
  blocks: (req, res) ->
    if not blocks.length
      do refreshBlocks
    res.json 200, blocks
