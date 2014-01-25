socket = io.connect("http://localhost:8001")

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

    socket.on 'fireside/blocks', (blocks) ->
      processBlocks blocks

    $http.get('/api/fireside/blocks')
      .success (blocks) ->
        processBlocks blocks
      .error (err) ->
        console.log err

