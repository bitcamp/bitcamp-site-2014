angular.module('bitcampApp')


.controller 'main', (
  $scope
  $rootScope
  $timeout
  $http
  starfieldShader
) ->
  $rootScope.starfieldShader = starfieldShader
  $rootScope.twinkle = false

  makeUser = ->
    $scope.user =
      name       : ''
      email      : ''
      university : ''
  makeUser()

  $scope.submit = (user) ->
    $scope.successText = '. . .'
    $timeout ->
      $http.post('/api/signup', $scope.user)
        .success ->
          $scope.signupSuccess = true
          $scope.successText = 'success! :)'
          $timeout ->
            makeUser()
            $scope.successText = null
            $scope.signupSuccess = false
          , 3000
        .error ->
          $scope.signupError = true
          $scope.successText = 'error :('
          $timeout (-> $scope.successText = null), 3000
    , 1200
  null


.controller 'main.main', (
  $scope
  $rootScope
  $timeout
  $http
  $stateParams
  $state
) ->
  $rootScope.twinkle = false

  $scope.$on 'treetent:click', (ev, $event) ->
    $state.go 'main.hh'
    $event.originalEvent.cancelBubble = true


.directive 'resize', ($window, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    resizeTo = null
    angular.element($window).bind 'resize', ->
      scope.$broadcast 'window:resize:start' unless resizeTo
      $timeout.cancel resizeTo if resizeTo
      resizeTo = $timeout ->
        scope.$broadcast 'window:resize:end'
        resizeTo = null
      , 500
      scope.$apply()


.controller 'main.hh', ($scope, $rootScope, $state, browserFocus) ->
  $rootScope.twinkle = true

  $scope.$on 'treetent:click', ->
    $state.go 'main.main'

  $scope.$on 'starfieldMouse:click', (ev) ->
    if browserFocus.focus
      $rootScope.$broadcast 'starfield:mask:toggle'

