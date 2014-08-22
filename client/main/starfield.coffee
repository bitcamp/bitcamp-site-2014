angular.module('bitcampApp')


.factory 'ZFilter', ->
  class ZFilter extends PIXI.AbstractFilter
    prototype: PIXI.AbstractFilter.prototype

    constructor: (@canvas, @blinkRate, @hasColor) ->
      @passes = [@]

      @fragmentSrc = ("""
        precision mediump float;

        varying vec2 vTextureCoord;

        uniform sampler2D uSampler;
        uniform vec2 resolution;
        uniform vec2 center;
        uniform vec4 randoms;
        uniform float time;

        bool hasColor = #{@hasColor};

        float t = 10.0 * time;

        void main(void) {
          gl_FragColor = vec4(1);

          t += 0.5 * (0.5 + 0.5*sin(t));

          vec2 mid = #{if hasColor then 'center' else 'resolution / 2.0'};
          vec2 xy = gl_FragCoord.xy - mid;

          if (hasColor) {

            // Circular motion if no mouse movement.
            if (hasColor && resolution != 2.0*center) {
              xy = vec2(
                xy.x + 50.0*cos(time * 5.0),
                xy.y + 50.0*sin(time * 5.0));
            }

            // Spiral function.
            float a = degrees(atan(xy.y, xy.x));
            float amod = mod(a + 0.5 * t - 120.0 * log(length(xy)), 30.0) ;
            if (amod < 15.0){
              // Rotating color gradient.
              vec2 uv = gl_FragCoord.xy / resolution.xy;
              gl_FragColor *= vec4(uv, 0.5 + 0.5*sin(0.1 * t * randoms.x), 1);
            }
          }

          // Sombrero function for opacity.
          float xySqrt = sqrt(
              (1.0 + 0.6*sin(0.3*t))*pow(0.04 * xy.x, 2.0)
            + (1.0 + 0.6*sin(0.3*t))*pow(0.04 * xy.y, 2.0));
          float alpha = sin(0.5 * t + xySqrt) / xySqrt;
          gl_FragColor *= 13.0*(1.0 - 0.25*(sin(0.2*t))) * sin(0.0002 * alpha * t);
        }

      """).split('\n')

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


.directive 'starfield', (starfieldMouse, ZFilter) ->
  restrict: 'A'
  scope:
    minDistance: '='
    sampleFrequency: '='
    blinkRate: '='
    hasColor: '='
  link: (scope, element, attrs) ->

    blinkRate = scope.blinkRate / 100

    hasColor = if scope.hasColor then true else false

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

    zfilter = new ZFilter(element, blinkRate, hasColor)

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
      zfilter.center = new Float32Array [
        element.width()  / 2
        element.height() / 2
      ]

    scope.$on 'starfieldMouse:move', ->
      zfilter.center = new Float32Array [
        element.width()  * +1 * starfieldMouse.x
        element.height() * -1 * starfieldMouse.y + element.height()
      ]

    makeSquares = ->
      stage.children.length = 0
      squares = new PIXI.Graphics()
      squares.beginFill()
      squares.drawRect(0, 0, element.width(), element.height())
      squares.endFill()
      squares.filters = [zfilter]
      stage.addChild(squares)
      squares

    makeMask = ->
      mask = new PIXI.Graphics()
      mask.beginFill()
      sampler = makeSampler scope.minDistance, scope.sampleFrequency
      while sampler.sample()
        s = sampler.outputList[sampler.outputList.length - 1]
        mask.drawRect(
          -(size/2) + (s.x / 100) * element.width(),
          -(size/2) + (s.y / 100) * element.height(),
          size, size)
      mask.endFill()
      mask

    make = (randoms = true, resolution = true) ->
      makeUniforms(randoms, resolution)
      squares = makeSquares()
      squares.mask = makeMask()

    render = () ->
      renderer.render stage

    renderLoop = ->
      zfilter.time = zfilter.time + 0.1*blinkRate
      render()
      requestAnimFrame renderLoop
    requestAnimFrame renderLoop

    scope.$on 'starfieldMouse:click', (ev, click) ->
      make()

    scope.$on 'window:resize:start', ->
      stage.alpha = 0
    scope.$on 'window:resize:end', ->
      renderer.resize(element.width(), element.height())
      stage.alpha = 1
      make(false, true)

    init = ->
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


