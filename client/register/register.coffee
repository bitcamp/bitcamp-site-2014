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
        label: "request travel stipend"
      ,
        field: "dietary"
        label: "dietary restrictions"
      ,
        field: "twitter"
        label: "twitter handle"
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

  .controller "RegisterCtrl_1", (
    $rootScope,
    $scope,
    $http,
    colors,
    $cookieStore,
    $state,
    $timeout) ->

    $rootScope.navBubbles = [true, false, false, false]
    $rootScope.bodyCSS["background-color"] = colors["green-light"]

    $scope.registerBtnText = "register"

    $scope.err = ->
      $scope.emailErr or $scope.confirmErr or $scope.passwordErr

    if $cookieStore.get "auth"
      $state.go "register.two"

    $scope.registering = false
    $scope.register = ->
      return if $scope.registering or $scope.registerSuccess
      $scope.registering = true

      $scope.registerBtnText = ". . ."

      $http.post("/api/register", {
        email:    $scope.email
        password: $scope.password
        confirm:  $scope.confirm
      })
        .success (data) ->
          $rootScope.api_messages = []
          $timeout ->
            $scope.registerBtnText = "check your email!"
            $scope.registerSuccess = true
            $scope.registering     = false
          , 2000

        .error (err) ->
          $scope.registerBtnText = ":("
          $rootScope.api_messages = []
          $scope.emailErr    = $rootScope.apiErr "email", err
          $scope.passwordErr = $rootScope.apiErr "password", err
          $scope.confirmErr  = $scope.password isnt $scope.confirm

          $timeout ->
            $scope.registerBtnText = "register"
            $scope.registering = false
          , 2000

          if $scope.confirmErr
            err.confirm = ["that your passwords match"]
            $scope.passwordErr = $rootScope.apiErr "confirm", err

        .finally ->
          $timeout ->
            $scope.emailErr    = ""
            $scope.passwordErr = ""
            $scope.confirmErr  = ""
            $scope.email       = ""
            $scope.password    = ""
            $scope.confirm     = ""
          , 2000


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
        .catch (err) ->
          $state.go "login.main"
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

    $scope.profile = profile.get()

    $scope.submitting = false
    $scope.submit = ->
      return if $scope.submitting
      $scope.submitting = true
      $scope.profile.$save()
        .then (data) ->
          $state.go "^.four"
        .catch (err) ->
          $state.go "login.main"
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
          $rootScope.registered = true
          $state.go "fireside"
        .catch (err) ->
          $state.go "login.main"
        .finally ->
          $scope.submitting = false

