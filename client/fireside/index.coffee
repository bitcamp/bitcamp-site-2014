socket = io.connect "50.22.11.232:13891"


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http, $resource) ->

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
          $scope.blocks_on.map (b, i) ->
            $b = $bs.eq i
            $b.removeClass $b.data 'colorclass'
            $b.addClass    $b.data 'dimclass'
          (b for b in blocks when b.on).map (b) ->
            $b = $bs.eq b.i
            $b.removeClass $b.data 'dimclass'
            $b.addClass    $b.data 'colorclass'
        .error (err) ->
          $scope.blocks_on = []

    blocksI = setInterval blocksF, 10000
