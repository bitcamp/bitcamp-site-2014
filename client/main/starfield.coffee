angular.module('bitcampApp')


.factory 'ZFilter', ->
  class ZFilter extends PIXI.AbstractFilter
    prototype: PIXI.AbstractFilter.prototype

    constructor: (@canvas, @blinkRate, @hasColor, @shader) ->
      @passes = [@]

      @fragmentSrc = _.template(@shader, {
        @hasColor
      }).split('\n')

      @uniforms =

        resolution:
          type: '2fv'
          value: [0, 0]

        center:
          type: '2fv'
          value: [0, 0]

        time:
          type: '1f'
          value: 1024

        randoms:
          type: '4fv'
          value: [1, 1, 1, 1]

      super(@fragmentSrc, @uniforms)

    Object.defineProperties @prototype, resolution:
      get: -> @uniforms.resolution.value
      set: (value) ->
        @dirty = true
        @uniforms.resolution.value = value

    Object.defineProperties @prototype, center:
      get: -> @uniforms.center.value
      set: (value) ->
        @dirty = true
        @uniforms.center.value = value

    Object.defineProperties @prototype, time:
      get: -> @uniforms.time.value
      set: (value) ->
        @dirty = true
        @uniforms.time.value = value

    Object.defineProperties @prototype, randoms:
      get: -> @uniforms.randoms.value
      set: (value) ->
        @dirty = true
        @uniforms.randoms.value = value


.directive 'starfield', (
  starfieldMouse
  ZFilter
  browserFocus
) ->
  restrict: 'A'
  scope:
    minDistance     : '='
    sampleFrequency : '='
    blinkRate       : '='
    hasColor        : '='
    shader          : '@'
  link: (scope, element, attrs) ->
    blinkRate = scope.blinkRate / 100

    hasColor = if scope.hasColor then true else false

    randomBetween = (min, max) ->
      min + Math.random() * max

    makeSampler = (
      minDistance     = scope.minDistance
      sampleFrequency = scope.sampleFrequency
      start           = null
    ) ->
      new PoissonDiskSampler 100, 100,
        minDistance, sampleFrequency, start

    renderer = PIXI.autoDetectRenderer(
      element.width()
      element.height()
      element[0]
      true
      true
    )

    stage   = new PIXI.Stage()
    mask    = new PIXI.Graphics()
    squares = new PIXI.Graphics()

    zfilter = new ZFilter(element, blinkRate, hasColor, scope.shader)

    makeUniforms = (randoms = true, resolution = true) ->
      if randoms
        zfilter.randoms = (randomBetween(0.1, 1) for _ in [0...4])
      if resolution
        zfilter.resolution = new Float32Array(
          [element.width(), element.height()])
      zfilter.center = new Float32Array [
        element.width()  / 2
        element.height() / 2
      ]

    scope.$on 'starfieldMouse:out', ->
      #zfilter.center = new Float32Array [
      #  element.width()  / 2
      #  element.height() / 2
      #]

    scope.$on 'starfieldMouse:move', ->
      #zfilter.center = new Float32Array [
      #  element.width()  * +1 * starfieldMouse.x
      #  element.height() * -1 * starfieldMouse.y + element.height()
      #]

    makeSquares = ->
      squares.clear()
      squares.beginFill()
      squares.drawRect(0, 0, element.width(), element.height())
      squares.endFill()

    makeMask = (size) ->
      sampler = makeSampler()
      w = element.width()
      h = element.height()
      mask.clear()
      mask.beginFill()
      while sampler.sample()
        s = sampler.outputList[sampler.outputList.length - 1]
        $size = (Math.random() * (size+1)) + (size-1)
        mask.drawRect(
          -($size/2) + (s.x / 100) * w,
          -($size/2) + (s.y / 100) * h,
          $size, $size)
      mask.endFill()

    make = (randoms = true, resolution = true) ->
      makeUniforms(randoms, resolution)
      makeSquares()
      makeMask(4)

    render = ->
      zfilter.time = zfilter.time + 0.1*blinkRate
      renderer.render stage

    renderLoop = ->
      render() if browserFocus.focus
      requestAnimFrame renderLoop
    requestAnimFrame renderLoop

    scope.$on 'starfield:mask:toggle', ->
      if squares.mask?
        squares.mask = null
      else
        squares.mask = mask
        makeSquares()

    scope.$on 'window:resize:start', ->
      stage.alpha = 0

    scope.$on 'window:resize:end', ->
      renderer.resize(element.width(), element.height())
      stage.alpha = 1
      make(false, true)

    init = ->
      squares.mask    = mask
      squares.filters = [zfilter]
      stage.addChild(squares)
      renderer.resize(element.width(), element.height())
      make()

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
      scope.$broadcast 'starfieldMouse:move'

    $(element).on 'mouseout', (event) ->
      scope.$broadcast 'starfieldMouse:out'

    $(element).on 'click', (ev) ->
      scope.$broadcast 'starfieldMouse:click', ev


