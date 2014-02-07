socket = io.connect "50.22.11.232:13891"


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http, $resource) ->

    $scope.blocks_on = []

    socket = io.connect()

    $scope.blocksI = 0
    $scope.delta_t = 4000
    $scope.blocks_on = []

    socket.on 'connect', ->
      socket.on '/api/fireside/blocks', (blocks) ->
      socket.on '/api/fireside/delta_t', (delta_t) ->
        clearInterval $scope.blocksI
        $scope. blocksI = setInterval blocksF, delta_t
        $scope.delta_t = delta_t

    Blocks = $resource '/api/fireside/blocks', {},
      get:
        method: 'GET'
        isArray: true

    do blocksF = ->
      $http.get('/api/fireside/blocks')
        .success (blocks) ->
          $bs = $ '.inner-block'
          $scope.blocks_on.map (b) ->
            $b = $bs.eq b.i
            $b.removeClass $b.data 'colorclass'
            $b.addClass    $b.data 'dimclass'
          $scope.blocks_on = []
          (b for b in blocks when b.on).map (b) ->
            $b = $bs.eq b.i
            $scope.blocks_on.push b
            $b.removeClass $b.data 'dimclass'
            $b.addClass    $b.data 'colorclass'
        .error (err) ->
          $scope.blocks_on = []

    blocksI = setInterval blocksF, 1400
