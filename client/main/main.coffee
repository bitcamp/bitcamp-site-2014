angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $rootScope, colors) ->
    $rootScope.bodyCSS["background-color"] = colors["blue-dark"]

    $scope.signup = ->
      console.log "stuff"
    null
