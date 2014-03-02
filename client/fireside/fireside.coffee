
randomN = (min, max) ->
  Math.random() * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $rootScope, $http, $resource, $timeout, $interval, colors) ->
    $scope.firesideCSS =
      "background-image": "linear-gradient(to bottom," +\
        "#{colors["blue-light"]}  40%, " + \
        "#{colors["blue-dark"]}   90%, " + \
        "#{colors["blue-darker"]} 100%"  + \
        ")"


    blocksI     = 0
    blocksT     = 2400
    blocksT_min = 100
    $bs = $(".fireside-block:not(.empty-block) .inner-block")

    requestAnimationFrame = window.requestAnimationFrame
    requestAnimationFrame or= (f) -> f()

    blocksF = ->
      blocks = $bs.map (i, b) ->
        i: i
        on: randomInt(0, $bs.length) < ($bs.length/4)
      (b for b in blocks when b.on).map (b) ->
        do ($b = $bs.eq b.i) ->
          $timeout((-> requestAnimationFrame ->
            $b.removeClass $b.data 'dimclass'
            $b.addClass    $b.data 'colorclass'
            $timeout((-> requestAnimationFrame ->
              $b.removeClass $b.data 'colorclass'
              $b.addClass    $b.data 'dimclass'
            ), (randomN blocksT_min, blocksT-blocksT_min))
          ), (randomN blocksT_min, blocksT-blocksT_min))

    blocksF()
    blocksI = $interval blocksF, blocksT
    $scope.$on "$destroy", -> $interval.cancel blocksI
