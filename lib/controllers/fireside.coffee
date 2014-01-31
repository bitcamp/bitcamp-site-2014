io = require("socket.io").listen 8001, {
  log: false
}


blocks = []


randomN = (min, max) ->
  Math.random * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


io.sockets.on "connection", (socket) ->

  blocksInterval = setInterval ->
    refreshBlocks()
    socket.emit 'fireside/blocks', blocks
  , 3000

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
    .fail (err) ->
      console.log err.message
    .done (bs) ->
      blocks = bs
