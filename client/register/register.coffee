bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", ($scope, $rootScope, $location) ->
    $rootScope.navBubble = 0

  .controller "RegisterCtrl_1", ($rootScope, colors) ->
    $rootScope.navBubble = 1
    $rootScope.bodyCSS["background-color"] = colors["green-light"]

  .controller "RegisterCtrl_2", ($rootScope, colors) ->
    $rootScope.navBubble = 2
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

  .controller "RegisterCtrl_3", ($rootScope, colors) ->
    $rootScope.navBubble = 3
    $rootScope.bodyCSS["background-color"] = colors["orange-dark"]

  .controller "RegisterCtrl_4", ($rootScope, colors) ->
    $rootScope.navBubble = 4
    $rootScope.bodyCSS["background-color"] = colors["blue-darker"]
