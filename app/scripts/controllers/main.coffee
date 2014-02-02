'use strict'

angular.module('bitcampApp')
  .controller 'MainCtrl', ($scope, $http) ->
    $http.get('/api/bitcamp')
      .success (data) ->
        null
      .error (data) ->
        null

  .controller 'SignupCtrl', ($scope, $http) ->
    $scope.name       = ''
    $scope.email      = ''
    $scope.university = ''

    $scope.schools = []

    $scope.submitText   = 'submit'
    submitDefault       = $scope.submitText
    submitSuccess       = 'good to go!'
    submitError         = 'error :('
    submitWait          = '. . .'
    submitWaiting       = false
    $scope.submitStyles = {}

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
      return if submitWaiting
      submitWaiting = true

      $scope.submitText = submitWait
      $scope.submitStyles["color"]            = "#e5d8cf" #grey-light
      $scope.submitStyles["background-color"] = "#7f6c60" #grey-dark

      $http
        method: 'POST'
        url: '/api/signup'
        data:
          name:       $scope.name
          email:      $scope.email
          university: $scope.university
        headers: 'Content-Type': 'application/json'

      .success (data) ->
        $scope.submitText                       = submitSuccess
        $scope.submitStyles["background-color"] = "white"
        $scope.submitStyles["color"]            = "#53a559"

        setTimeout ->
          $scope.$apply ->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
            $scope.name         = ''
            $scope.email        = ''
            $scope.university   = ''
        , submitDelay

      .error (data) ->
        $scope.submitText                       = submitError
        $scope.submitStyles["background-color"] = "#ff404a"
        $scope.submitStyles["color"]            = "white"

        setTimeout ->
          $scope.$apply ->
            $scope.submitText   = submitDefault
            $scope.submitStyles = {}
        , submitDelay

      .finally ->
        submitWaiting = false

