{db, io, ready} = require '../'


blocks = []


randomN = (min, max) ->
  Math.random * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


ready.then ->
  io.sockets.on "connection", (socket) ->
    blocksInterval = setInterval ->
      refreshBlocks()
      socket.emit 'api/fireside/blocks', blocks
    , 10000

    socket.on 'disconnect', ->
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
      res.json 200, blocks
    .done ->
      res.json 200, blocks
