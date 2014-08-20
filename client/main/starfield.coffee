angular.module('bitcampApp')


.factory 'ZFilter', ->
  class ZFilter extends PIXI.AbstractFilter
    prototype: PIXI.AbstractFilter.prototype

    constructor: (@canvas, @blinkRate) ->
      @passes = [@]

      @fragmentSrc = ("""
        precision mediump float;

        uniform float time;
        uniform vec2 resolution;
        uniform vec4 randoms;

        void main(void) {
          vec2 xy = gl_FragCoord.xy - (resolution / 2.0);

          xy *= randoms.z * 0.05;

          float root = sqrt(pow(xy.x, 2.0) + pow(xy.y, 2.0));
          float a = sin(root) / root;

          gl_FragColor = vec4(1, 1, 1, 1);
          gl_FragColor *= sin(
              (randoms.x * 20.0 * a)
            + (randoms.y * 10.0 * #{@blinkRate.toFixed 1} * time));
        }
      """).split('\n')

      @uniforms =

        resolution:
          type: '2fv'
          value: [0, 0]

        time:
          type: '1f'
          value: 0

        randoms:
          type: '4fv'
          value: [1, 1, 1, 1]

      super(@fragmentSrc, @uniforms)

    Object.defineProperties @prototype, resolution:
      get: -> @uniforms.resolution.value
      set: (value) ->
        @dirty = true
        @uniforms.resolution.value = value

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


.directive 'starfield', (starfieldMouse, ZFilter) ->
  restrict: 'A'
  scope:
    minDistance: '='
    sampleFrequency: '='
    blinkRate: '='
  link: (scope, element, attrs) ->

    blinkRate = scope.blinkRate / 100

    size = 5

    randomBetween = (min, max) ->
      min + Math.random() * max

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

    zfilter = new ZFilter(element, blinkRate)

    squares = new PIXI.Graphics()
    squares.beginFill()
    squares.drawRect(0, 0,
      element.width(),
      element.height()
    )
    squares.endFill()
    squares.filters = [zfilter]
    stage.addChild(squares)

    newSampler = (start = null) ->
      zfilter.randoms = (randomBetween(0.1, 1) for _ in [0...4])
      zfilter.resolution = new Float32Array([element.width(), element.height()])
      sampler = makeSampler scope.minDistance, scope.sampleFrequency, start
      mask = new PIXI.Graphics()
      mask.beginFill()
      while sampler.sample()
        s = sampler.outputList[sampler.outputList.length - 1]
        mask.drawRect(
          -(size/2) + (s.x / 100) * element.width(),
          -(size/2) + (s.y / 100) * element.height(),
          size, size)
      mask.endFill()
      squares.mask = mask

    render = () ->
      renderer.render stage
    renderLoop = ->
      zfilter.time = zfilter.time + blinkRate
      render()
      requestAnimFrame renderLoop
    requestAnimFrame renderLoop

    scope.$on 'starfieldMouse:click', (ev, click) ->
      dt = 0
      newSampler()

    scope.$on 'window:resize:start', ->
      stage.children.length = 0

    init = ->
      renderer.resize(
        element.width()
        element.height()
      )
      newSampler()
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


