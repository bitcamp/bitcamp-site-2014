angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $rootScope, colors, $timeout, $http) ->
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

    makeSignup = ->
      $scope.signup =
        name:       ""
        email:      ""
        university: ""
    makeSignup()
    $scope.submit = ->
      $scope.successText = ". . ."
      $timeout ->
        $http.post("/api/signup", $scope.signup)
          .success ->
            $scope.signupSuccess = true
            $scope.successText = "success! :)"
            $timeout ->
              makeSignup()
              $scope.successText = null
              $scope.signupSuccess = false
            , 3000
          .error ->
            $scope.signupError = true
            $scope.successText = "error :("
            $timeout (-> $scope.successText = null), 3000
      , 1200
    null
