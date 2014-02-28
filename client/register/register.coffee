bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", ($scope, $rootScope, $location) ->
    $rootScope.navBubbles = [false, false, false, false]

  .controller "RegisterCtrl_1", ($rootScope, colors) ->
    $rootScope.navBubbles = [true, false, false, false]
    $rootScope.bodyCSS["background-color"] = colors["green-light"]

  .controller "RegisterCtrl_2", ($rootScope, colors) ->
    $rootScope.navBubbles = [true, true, false, false]
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

  .controller "RegisterCtrl_3", ($rootScope, colors) ->
    $rootScope.navBubbles = [true, true, true, false]
    $rootScope.bodyCSS["background-color"] = colors["orange-dark"]

  .controller "RegisterCtrl_4", ($rootScope, colors) ->
    $rootScope.navBubbles = [true, true, true, true]
    $rootScope.bodyCSS["background-color"] = colors["blue-darker"]
