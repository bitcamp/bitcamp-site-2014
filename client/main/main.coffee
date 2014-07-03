angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $rootScope, colors, $timeout) ->
    $rootScope.bodyCSS["background-color"] = colors["blue-dark"]

    #makeStars = (minDistance=22, sampleFrequency=10)->
    makeStars = (minDistance=2.0, sampleFrequency=3)->
      starSampler = new PoissonDiskSampler 94, 94, minDistance, sampleFrequency
      $scope.stars = starSampler.sampleUntilSolution()
      $scope.stars.forEach (star) ->
        star.x += 2
        star.y += 2
      $scope.stars.reverse()

    $scope.twinkle = false
    clicking = false
    $rootScope.$on "treetent:click", ->
      return if clicking
      clicking = true
      if $scope.twinkle
        makeStars 22, 10
        clicking = false
      else
        makeStars()
        $timeout ->
          clicking = false
          $rootScope.$emit "treetent:click"
        , (100 + $scope.stars.length * 7.5)
      $scope.twinkle = not $scope.twinkle

    $scope.$on "$viewContentLoaded", -> makeStars(22, 10)

    $scope.signup = ->
      console.log "stuff"
    null
