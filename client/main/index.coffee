angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http, $window) ->

    $http.get('/api/bitcamp')
      .success (data) ->
        null
      .error (data) ->
        null

  .controller 'SignupCtrl', ($scope, $http) ->
    $scope.name       = ''
    $scope.email      = ''
    $scope.university = ''

    $scope.submitText   = 'submit'
    submitDefault       = $scope.submitText
    submitSuccess       = 'good to go!'
    submitError         = 'error :('
    submitWait          = '. . .'
    submitWaiting       = false
    $scope.submitStyles = {}

    submitDelay = 2000 # milliseconds

    $scope.signup = ->
      return if submitWaiting
      submitWaiting = true

      $scope.submitText = submitWait
      $scope.submitStyles["color"]            = "#e5d8cf" #grey-light
      $scope.submitStyles["background-color"] = "#7f6c60" #grey-dark

      $http
        method: 'POST'
        url: '/api/signup'
        data:
          name:       $scope.name
          email:      $scope.email
          university: $scope.university
        headers: 'Content-Type': 'application/json'

      .success (data) ->
        $scope.submitText                       = submitSuccess
        $scope.submitStyles["background-color"] = "white"
        $scope.submitStyles["color"]            = "#53a559"

        setTimeout ->
          $scope.$apply ->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
            $scope.name         = ''
            $scope.email        = ''
            $scope.university   = ''
        , submitDelay

      .error (data) ->
        $scope.submitText                       = submitError
        $scope.submitStyles["background-color"] = "#ff404a"
        $scope.submitStyles["color"]            = "white"

        setTimeout ->
          $scope.$apply ->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
        , submitDelay

      .finally ->
        submitWaiting = false

