'use strict'

angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http) ->
    $http.get('/api/bitcamp')
      .success (data) ->
        null
      .error (data) ->

  .controller 'SignupCtrl', ($scope, $http) ->
    $scope.name       = ''
    $scope.email      = ''
    $scope.university = ''

    $scope.schools = []

    submitDelay = 2000 # milliseconds

    $scope.autocompleteOptions =
      options:
        html:       true
        focusOpen:  false
        onlySelect: false
        minLength:  3
        methods:    {}
        outHeight:  200
        source:     (req, res) ->
          process = ->
            schools = $scope.schools.slice()
            schools = $scope.autocompleteOptions.methods.filter schools, req.term
            res schools

          if $scope.schools.length is 0
            $http.get('/api/schools')
              .success (schools) ->
                $scope.schools = schools
                do process
              .error (schools) ->
                console.log "Error :(!"
          else
            do process

    $scope.signup = ->
      $http
        method: 'POST'
        url: '/api/signup'
        data:
          name:       $scope.name
          email:      $scope.email
          university: $scope.university
        headers: 'Content-Type': 'application/json'
      .success (data) ->
        $("#permission #signup").val 'good to go'
        $("#permission #signup").css 'background-color': 'white'
        $("#permission #signup").css 'color': '#53a559'
        setTimeout ->
          $("#permission #signup").val 'submit'
          $("#permission #signup").css 'background-color': ''
          $("#permission #signup").css 'color': ''
          $("#permission input").not(':button, :submit, :reset, :hidden').val ''
        , submitDelay
      .error (data) ->
        $("#permission #signup").val 'error :('
        $("#permission #signup").css 'background-color': '#ff404a'
        $("#permission #signup").css 'color': 'white'
        setTimeout ->
          $("#permission #signup").val 'submit'
          $("#permission #signup").css 'background-color': ''
          $("#permission #signup").css 'color': ''
        , submitDelay

