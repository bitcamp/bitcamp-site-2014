angular.module('bitcampApp')
  .controller 'WaiverCtrl', ($scope, $http, profile) ->
    $scope.name - ""
    $scope.profile = profile.get ->
      $scope.name = "#{$scope.profile.first} #{$scope.profile.last}"
    $scope.submit = ->
      $http.post('/api/waiver', {
        agreed: true
        name: $scope.name
      })
      .success((data, status, headers, config) ->
        console.log(data)
        $scope.name = ""
      )
      .error((data, status, headers, config) ->
        console.log(data)
      )
