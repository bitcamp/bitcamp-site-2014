angular.module('bitcampApp')


.controller 'MainCtrl', (
  $scope
  $rootScope
  $timeout
  $http
  $stateParams
  $state
) ->
  $rootScope.twinkle = false

  $scope.$on 'treetent:click', ->
    $state.go 'main.hh'

  makeSignup = ->
    $scope.signup =
      name:       ''
      email:      ''
      university: ''
  makeSignup()
  $scope.submit = ->
    $scope.successText = '. . .'
    $timeout ->
      $http.post('/api/signup', $scope.signup)
        .success ->
          $scope.signupSuccess = true
          $scope.successText = 'success! :)'
          $timeout ->
            makeSignup()
            $scope.successText = null
            $scope.signupSuccess = false
          , 3000
        .error ->
          $scope.signupError = true
          $scope.successText = 'error :('
          $timeout (-> $scope.successText = null), 3000
    , 1200
  null


.directive 'resize', ($window, $timeout) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    w = angular.element($window)
    resizeTo = null
    w.bind 'resize', ->
      scope.$broadcast 'window:resize:start' unless resizeTo
      $timeout.cancel resizeTo if resizeTo
      resizeTo = $timeout ->
        scope.$broadcast 'window:resize:end'
        resizeTo = null
      , 500
      scope.$apply()


.controller 'hhCtrl', ($scope, $rootScope, $state) ->
  $rootScope.twinkle = true

  $scope.$on 'treetent:click', ->
    $state.go 'main.main'

