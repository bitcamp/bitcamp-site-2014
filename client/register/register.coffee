bitcamp = angular.module("bitcampApp")

  .controller "RegisterCtrl", ($scope, $rootScope, $location, $cookieStore, $timeout) ->
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
        field: "transportation"
        label: "mode of transportation"
      ,
        field: "stipend"
        label: "travel stipend"
      ,
        field: "dietary_restrictions"
        label: "dietary restrictions"
      ,
        field: "tshirt_size"
        label: "t-shirt size"
      ,
        field: "github"
        label: "github username"
      ,
        field: "website"
        label: "website url"
      ,
        field: "blurb"
        label: "hopes and dreams"
    ]

    if $cookieStore.get "auth"
      $rootScope.profile.get()
        .$promise.then (data) ->
          $scope.profile = data
          $scope.profile.stipend or= false


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


  .controller "RegisterCtrl_2", ($scope, $rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, false, false]
    $rootScope.bodyCSS["background-color"] = colors["blue-darker"]

  .controller "RegisterCtrl_3", ($scope, $rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, true, false]
    $rootScope.bodyCSS["background-color"] = colors["orange-dark"]

  .controller "RegisterCtrl_4", ($scope, $rootScope, colors, $cookieStore, $state) ->
    $rootScope.navBubbles = [true, true, true, true]
    $rootScope.bodyCSS["background-color"] = colors["blue-light"]

    $scope.submit = ->
      $rootScope.profile.save()
        .$promise.then (data) ->
          console.log data
          $state.go "fireside"
        .catch (data) ->
          console.log "PRETENDING LIKE WE SAVED THE PROFILE ;)"
          $rootScope.profile$.complete = true
          $state.go "fireside"

