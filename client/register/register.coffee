bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", (
    $scope,
    $rootScope,
    $location,
    $cookieStore,
    $timeout) ->

    $rootScope.api_messages = []

    $scope.email    = ""
    $scope.password = ""
    $scope.confirm  = ""
    $rootScope.$on "register", ->
      $timeout ->
        $scope.email    = ""
        $scope.password = ""
        $scope.confirm  = ""
      , 3000

    $scope.profile_fields = [
        field: "first"
        label: "first name"
      ,
        field: "last"
        label: "last name"
      ,
        field: "school"
        label: "school"
      ,
        field: "travel"
        label: "mode of transportation"
      ,
        field: "stipend"
        label: "travel stipend"
      ,
        field: "dietary"
        label: "dietary restrictions"
      ,
        field: "tshirt"
        label: "t-shirt size"
      ,
        field: "github"
        label: "github username"
      ,
        field: "resume"
        label: "resume url"
      ,
        field: "website"
        label: "website url"
      ,
        field: "blurb"
        label: "hopes and dreams"
    ]

    $rootScope.apiErr = (name, errObj) ->
      if errObj[name]
        m = "#{name} #{errObj[name][errObj[name].length-1]}"
        $rootScope.api_messages.push m
        m
      else false

    null

  .controller "RegisterCtrl_1", ($rootScope, $scope, $http, colors, $cookieStore, $state, $timeout) ->
    $rootScope.navBubbles = [true, false, false, false]
    $rootScope.bodyCSS["background-color"] = colors["green-light"]

    $scope.registerBtnText = "register"

    $scope.err = ->
      $scope.emailErr or $scope.confirmErr or $scope.passwordErr

    $scope.registering = false
    $rootScope.$on "register", ->
      return if $scope.registering
      $scope.registering = true
      $timeout ->
        $scope.registering = false
        $scope.emailErr     = ""
        $scope.passwordErr  = ""
        $scope.confirmErr   = ""
        $scope.registerBtnText = "register"
      , 3000

    if $cookieStore.get "auth"
      $state.go "register.two"

    $scope.register = ->
      $http.post("/api/register", {
        email:    $scope.email
        password: $scope.password
        confirm:  $scope.confirm
      })
        .success (data) ->
          $rootScope.api_messages = []
          $rootScope.$emit "register", null, data
          null
        .error (err) ->
          $scope.registerBtnText = ":("
          $rootScope.$emit "register", err
          $rootScope.api_messages = []
          $scope.emailErr    = $rootScope.apiErr "email", err
          $scope.passwordErr = $rootScope.apiErr "password", err
          $scope.confirmErr  = $scope.password isnt $scope.confirm

          if $scope.confirmErr
            err.confirm = ["that your passwords match"]
            $scope.passwordErr = $rootScope.apiErr "confirm", err


  .controller "RegisterCtrl_2", (
    $scope,
    $rootScope,
    $cookieStore,
    $state,
    colors,
    profile) ->

    $rootScope.navBubbles = [true, true, false, false]
    $rootScope.bodyCSS["background-color"] = colors["blue-darker"]

    $scope.profile = profile.get ->
      $scope.profile.stipend or= false

    $scope.submitting = false
    $scope.submit = ->
      return if $scope.submitting
      $scope.submitting = true
      $scope.profile.$save()
        .then (data) ->
          $state.go "^.three"
          unless $scope.profile.first and
                 $scope.profile.last  and
                 $scope.profile.travel
            throw exception
        .catch (err) ->
          console.log err
        .finally ->
          $scope.submitting = false



  .controller "RegisterCtrl_3", (
    $scope,
    $rootScope,
    colors,
    $cookieStore,
    $state,
    profile) ->

    $rootScope.navBubbles = [true, true, true, false]
    $rootScope.bodyCSS["background-color"] = colors["orange-dark"]

    $scope.profile = profile.get ->
      console.log $scope.profile

    $scope.submitting = false
    $scope.submit = ->
      return if $scope.submitting
      $scope.submitting = true
      $scope.profile.$save()
        .then (data) ->
          $state.go "^.four"
        .catch (err) ->
          console.log err
        .finally ->
          $scope.submitting = false


  .controller "RegisterCtrl_4", (
    $scope,
    $rootScope,
    colors,
    $cookieStore,
    $state,
    profile) ->

    $rootScope.navBubbles = [true, true, true, true]
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

    $scope.profile = profile.get()

    $scope.submitting = false
    $scope.submit = ->
      return if $scope.submitting
      $scope.submitting = true
      $scope.profile.$save()
        .then (data) ->
          $state.go "fireside"
        .catch (err) ->
          console.log err
        .finally ->
          $scope.submitting = false

