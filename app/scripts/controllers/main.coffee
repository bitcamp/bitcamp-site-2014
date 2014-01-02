'use strict'

angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http) ->
    $http.get('/api/bitcamp').success (json) ->
      $scope.json = json
