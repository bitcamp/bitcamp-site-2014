angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http, $anchorScroll) ->
    null

  .controller 'SignupCtrl', ($scope, $http, $timeout) ->
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

    submitDelay = 1400 # milliseconds

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
        $timeout (->
          $scope.submitText                       = submitSuccess
          $scope.submitStyles["background-color"] = "white"
          $scope.submitStyles["color"]            = "#53a559"
          $timeout (->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
            $scope.name         = ''
            $scope.email        = ''
            $scope.university   = ''
          ), submitDelay
        ), submitDelay

      .error (data) ->
        $timeout (->
          $scope.submitText                       = submitError
          $scope.submitStyles["background-color"] = "#ff404a"
          $scope.submitStyles["color"]            = "white"
          $timeout (->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
          ), submitDelay
        ), submitDelay

      .finally ->
        submitWaiting = false

