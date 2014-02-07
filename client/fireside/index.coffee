socket = io.connect "50.22.11.232:13891"


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http, $resource) ->

    socket = io.connect()

    $scope.blocksI = 0
    $scope.delta_t = 4000
    $scope.blocks_on = []

    socket.on 'connect', ->
      socket.on '/fireside/delta_t', (delta_t) ->
        clearInterval $scope.blocksI
        $scope. blocksI = setInterval blocksF, delta_t
        $scope.delta_t = delta_t

    Blocks = $resource '/api/fireside/blocks', {},
      get:
        method: 'GET'
        isArray: true

    do blocksF = ->
      $scope.blocks = Blocks.get ->
        $bs = $ '.inner-block'

        $scope.blocks_on.map (i) ->
          $b = $bs.eq i
          $b.removeClass $b.data 'colorclass'
          $b.addClass    $b.data 'dimclass'

        $scope.blocks_on = []

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

