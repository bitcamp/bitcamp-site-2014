socket = io.connect "50.22.11.232:13891"

angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http) ->

    onBlocks = []

    processBlocks = (blocks) ->
      $bs = $ '.inner-block'

      onBlocks.map (i) ->
        $b = $bs.eq i
        $b.removeClass $b.data 'colorclass'
        $b.addClass    $b.data 'dimclass'

      onBlocks = []

      blocks.map (b, i) ->
        $b = $bs.eq i
        if b.on is true
          $b.removeClass $b.data 'dimclass'
          $b.addClass    $b.data 'colorclass'
          onBlocks.push i

    socket.on '/api/fireside/blocks', (blocks) ->
      processBlocks blocks

    syncBlocks = ->
      $http.get('/api/fireside/blocks')
        .success (blocks) ->
          processBlocks blocks
        .error (err) ->
          console.log err

    blocksI = setInterval syncBlocks, 10000

    syncBlocks()

