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
        $("#permission #signup").css 'background-color': 'green'
        setTimeout ->
          $("#permission input").not(':button, :submit, :reset, :hidden').val ''
          $("#permission #signup").css 'background-color': ''
        , 500
      .error (data) ->
        $("#permission #signup").css 'background-color': 'red'
        setTimeout ->
          $("#permission #signup").css 'background-color': ''
        , 500
