bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", ($http, $scope, $rootScope, colors) ->
    null

  .controller "RegisterCtrl.p1", ($rootScope, colors) ->
    $rootScope.bodyCSS["background-color"] = colors["blue-dark"]
