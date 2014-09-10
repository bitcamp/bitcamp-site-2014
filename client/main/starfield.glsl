precision mediump float;


varying vec2 vTextureCoord;


uniform sampler2D uSampler;
uniform vec2      resolution;
uniform vec2      center;
uniform vec4      randoms;
uniform float     time;


float t = 10.0 * time;


void main(void) {
  gl_FragColor = vec4(1);

  t += 0.5 * (0.5 + 0.5 * sin(t));

  <% if (hasColor === true) { %>
    vec2 xy = gl_FragCoord.xy - center;
  <% } else { %>
    vec2 xy = gl_FragCoord.xy - resolution / 2.0;
  <% } %>

  <% if (hasColor === true) { %>
    // Distortion
    float size = 40.0 + 20.0 * cos(t * -0.1);
    xy = vec2(
      xy.x - size + size*(1.0 + 0.4*sin(time * 0.025 * xy.x + xy.y)),
      xy.y - size + size*(1.0 + 0.4*sin(time * 0.025 * xy.y + xy.x)));

    // Spiral function.
    float a = degrees(atan(xy.y, xy.x));
    float amod = mod(a + 0.5 * t - 120.0 * log(length(xy)), 30.0) ;

    if (amod < 15.0) {
      // Rotating color gradient.
      vec2 uv = gl_FragCoord.xy / resolution.xy;
      gl_FragColor *= vec4(uv, 0.5 + 0.5 * sin(0.1 * t * randoms.x), 1);
    }
  <% } %>

  // Sombrero function for opacity.
  float ringFrequency = sin(randoms.w * 0.15 * t),
        ringSize      = (1.0 + 0.40 * ringFrequency) * 0.020,
        ringSpacing   = (1.0 + 0.28 * ringFrequency);

  float sombrero = sqrt(
      ringSpacing*pow(ringSize * xy.x, 2.0)
    + ringSpacing*pow(ringSize * xy.y, 2.0));

  float alpha = sin(0.30 * t + sombrero) / sombrero;

  float pulsingRadialOpacity = 13.0 - 12.0*(1.0 + 0.5*sin(0.15*t));

  gl_FragColor *= pulsingRadialOpacity
    * (1.0 - 0.25*(sin(0.2*t)))
    * sin(0.0002 * alpha * t);
}

