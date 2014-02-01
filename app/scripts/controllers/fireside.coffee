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

    Blocks = $resource '/fireside/blocks', {},
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

        $scope.blocks.map (b, i) ->
          $b = $bs.eq i
          if b.on is true
            $b.removeClass $b.data 'dimclass'
            $b.addClass    $b.data 'colorclass'
            $scope.blocks_on.push i

    $scope. blocksI = setInterval blocksF, 4000

