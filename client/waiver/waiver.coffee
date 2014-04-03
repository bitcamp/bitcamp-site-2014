angular.module('bitcampApp')
  .controller 'WaiverCtrl', ($scope, $http, profile) ->
    $scope.name  = ""
    $scope.name2 = ""
    $scope.done = false
    $scope.profile = profile.get ->
      $scope.name = "#{$scope.profile.first} #{$scope.profile.last}"
    $scope.submit = ->
      $http.post('/api/waiver', {
        agreed: true
        name: $scope.name2
      })
      .success((data, status, headers, config) ->
        console.log(data)
        $scope.name = ""
        $scope.done = true
      )
      .error((data, status, headers, config) ->
        console.log(data)
      )
