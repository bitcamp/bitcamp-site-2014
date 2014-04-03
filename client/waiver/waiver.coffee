angular.module('bitcampApp')
  .controller 'WaiverCtrl', ($scope, $http, profile) ->

    $scope.name  = ""
    $scope.done = false

    $http.get('/api/waiver')
    .success((data, status, headers, config) ->
      if data.first and data.last
        $scope.name = "#{data.first} #{data.last}"
      else
        $scope.done = true
        $scope.profile = profile.get (data) ->
          $scope.name2 = "#{data.first} #{data.last}"
    )
    .error((data, status, headers, config) ->
    )

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
