{db, io, ready} = require '../'


blocks = []


randomN = (min, max) ->
  Math.random() * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

# Decreasing values; safe in 0 < x < 200.
delta_t = (x) ->
  Math.floor(100000 / Math.log(16*(x + 1)))


ready.then ->

  io.sockets.on "connection", (socket) ->
    t = delta_t io.sockets.clients().length
    socket.broadcast.emit '/fireside/delta_t', t
    socket          .emit '/fireside/delta_t', t

    blocksInterval = setInterval refreshBlocks, t

    socket.on 'disconnect', ->
      t = delta_t(io.sockets.clients().length - 1)
      socket.broadcast.emit '/fireside/delta_t', t
      socket          .emit '/fireside/delta_t', t

      clearInterval blocksInterval


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
    .then (bs) ->
      blocks = bs

exports.blocks = (req, res) ->
  refreshBlocks()
    .fail (err) ->
      console.log err
      res.json 500, []
    .done ->
      res.json 200, blocks
