'use strict'

angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http) ->
    $http.get('/api/bitcamp')
      .success (data) ->
        null
      .error (data) ->

  .controller 'SignupCtrl', ($scope, $http) ->
    $scope.name       = ''
    $scope.email      = ''
    $scope.university = ''

    submitDelay = 2000 # milliseconds

    $scope.signup = ->
      $http
        method: 'POST'
        url: '/api/signup'
        data:
          name:       $scope.name
          email:      $scope.email
          university: $scope.university
        headers: 'Content-Type': 'application/json'
      .success (data) ->
        $("#permission #signup").val 'good to go'
        $("#permission #signup").css 'background-color': 'white'
        $("#permission #signup").css 'color': '#53a559'
        setTimeout ->
          $("#permission #signup").val 'submit'
          $("#permission #signup").css 'background-color': ''
          $("#permission #signup").css 'color': ''
          $("#permission input").not(':button, :submit, :reset, :hidden').val ''
        , submitDelay
      .error (data) ->
        $("#permission #signup").val 'error :('
        $("#permission #signup").css 'background-color': '#ff404a'
        $("#permission #signup").css 'color': 'white'
        setTimeout ->
          $("#permission #signup").val 'submit'
          $("#permission #signup").css 'background-color': ''
          $("#permission #signup").css 'color': ''
        , submitDelay

