angular.module('bitcampApp')


.controller 'MainCtrl', (
  $scope
  $rootScope
  $timeout
  $http
  $stateParams
) ->

  $scope.twinkle = $stateParams.hh?

  $rootScope.$on 'treetent:click', ->
    $scope.twinkle = not $scope.twinkle

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
    w.bind 'resize', =>
      scope.$broadcast 'window:resize:start' unless resizeTo
      $timeout.cancel resizeTo if resizeTo
      resizeTo = $timeout ->
        scope.$broadcast 'window:resize:end'
        resizeTo = null
      , 500
      scope.$apply()


.directive 'starfield', (starfieldMouse) ->
  restrict: 'A'
  scope:
    minDistance: '='
    sampleFrequency: '='
    blinkRate: '='
  link: (scope, element, attrs) ->
    makeSampler = (minDistance = 2.4, sampleFrequency = 7, start = null) ->
      new PoissonDiskSampler 100, 100,
        minDistance, sampleFrequency, start

    renderer = PIXI.autoDetectRenderer(
      element.width()
      element.height()
      element[0]
      true
      true
    )

    stage = new PIXI.Stage()

    newSampler = (start = null, reverse = null) ->
      stage.children.length = 0
      sampler = makeSampler attrs.minDistance, attrs.sampleFrequency, start
      while sampler.sample()
        s = sampler.outputList[sampler.outputList.length - 1]
        g = new PIXI.Graphics()
        g.beginFill(0xFFFFFF)
        g.drawRect(
          (s.x / 100) * element.width(),
          (s.y / 100) * element.height(),
          5, 5)
        g.endFill()
        stage.addChild(g)
      stage.children.reverse() if reverse

    init = ->
      sampler = newSampler()
      renderer.resize(
        element.width()
        element.height()
      )

    f1 = (x) ->
      # A sine wave between zero and one.
      (1/2)*(Math.sin(x) + 1)
    f2 = (x) ->
      # Derp.
      (1.5)*(Math.sin(x) - 0.618)

    f = if attrs.f2 then f2 else f1

    render = (dt) ->
      for s,i in stage.children
        s.alpha = Math.max f((i * 0.01) + dt), 0
      renderer.render stage

    dt = 0
    renderLoop = ->
      dt += 0.01 * attrs.blinkRate
      render(dt)
      requestAnimFrame renderLoop
    requestAnimFrame renderLoop

    scope.$on 'starfieldMouse:click', (ev, click) ->
      dt = 0
      newSampler {
        x: 100 * starfieldMouse.x
        y: 100 * starfieldMouse.y
      }, true

    scope.$on 'window:resize:start', ->
      stage.children.length = 0
    scope.$on 'window:resize:end', init
    init()


.factory 'starfieldMouse', ->
  { x: -1, y: -1 }


.directive 'starfieldMouse', ($window, starfieldMouse) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    $(element).on 'mousemove', (event) ->
      starfieldMouse.x = (event.clientX) / element.width()
      yOffset = element.offset().top - $(window).scrollTop()
      starfieldMouse.y = (event.clientY - yOffset) / element.height()
    $(element).on 'click', (ev) ->
      scope.$broadcast 'starfieldMouse:click', ev

