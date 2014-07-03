angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $rootScope, colors, $timeout) ->
    $rootScope.bodyCSS["background-color"] = colors["blue-dark"]

    makeStars = (minDistance=2.4, sampleFrequency=7)->
      starSampler = new PoissonDiskSampler 94, 94, minDistance, sampleFrequency
      stars = starSampler.sampleUntilSolution()
      stars.forEach (star) ->
        star.x += 2
        star.y += 2
      stars.reverse()
      stars

    $scope.stars1 = makeStars 22, 10

    $scope.twinkle = false
    clicking = false
    $rootScope.$on "treetent:click", ->
      return if clicking
      clicking = true
      $scope.twinkle = not $scope.twinkle
      $scope.stars1 = null if     $scope.twinkle
      $scope.stars2 = null unless $scope.twinkle
      $timeout ->
        $scope.stars1 = makeStars 22,  10 unless $scope.twinkle
        $scope.stars2 = makeStars 2.4, 7  if     $scope.twinkle
        clicking = false
      , 400

    $scope.$on "$viewContentLoaded", -> makeStars 23, 20

    $scope.signup = ->
      console.log "stuff"
    null
