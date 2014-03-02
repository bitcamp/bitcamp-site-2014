
randomN = (min, max) ->
  Math.random() * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http, $resource, $timeout) ->
    blocksI = 0
    blocksT = 2400

    $bs = $(".fireside-block:not(.empty-block) .inner-block")
    do blocksF = ->

      blocks = $bs.map (i, b) ->
        i: i
        on: randomInt(0, $bs.length) < ($bs.length/4)

      (b for b in blocks when b.on).map (b) ->
        do ($b = $bs.eq b.i) ->
          $timeout ->
            $b.removeClass $b.data 'dimclass'
            $b.addClass    $b.data 'colorclass'
            $timeout ->
              $b.removeClass $b.data 'colorclass'
              $b.addClass    $b.data 'dimclass'
            , (randomN 1, blocksT)
          , (randomN 1, blocksT)

    blocksI = setInterval blocksF, blocksT

    $scope.$on "$destroy", ->
      clearInterval blocksI
