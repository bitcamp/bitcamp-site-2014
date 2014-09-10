module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  _ = require('underscore')

  deps = require('./bower.json').dependencies

  cdnData = _.extend require('cdnjs-cdn-data'), require('google-cdn-data')
  cdnData = _.extend cdnData,
    underscore: cdnData['underscore.js']
  cdnData['animate.css'].versions.push deps['animate.css']
  cdnData['pixi.js'    ].versions.push deps['pixi.js']


  grunt.initConfig
    bitcamp:
      app  : "client"
      srv  : "server"

      tmp  : ".tmp"
      dist : "public"


    express:
      options:
        cmd: process.env.COFFEE or "./node_modules/.bin/coffee"

      dev:
        options:
          script: "bitcamp.coffee"
          node_env: "development"
          port: process.env.PORT or 8000

      prod:
        options:
          script: "bitcamp.coffee"
          node_env: "production"
          port: process.env.PORT or 8000


    prettify:
      dist:
        expand: true
        cwd: "<%= bitcamp.dist %>"
        src: [
          "**/*.html"
          "!bower_components/**"
        ]
        dest: "<%= bitcamp.dist %>"

    watch:
      views_templates:
        files: [
          "<%= bitcamp.app %>/**/*.jade",
          "!<%= bitcamp.app %>/index.jade"
        ]
        tasks: [ "newer:jade:templates" ]
      views_index:
        files: [ "<%= bitcamp.app %>/index.jade" ]
        tasks: [ "newer:jade:index" ]

      scripts:
        files: ["<%= bitcamp.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      styles:
        files: ["<%= bitcamp.app %>/**/*.sass"]
        tasks: [ "compass:dev", "autoprefixer" ]

      livereload_css:
        options: livereload: true
        files: [ "<%= bitcamp.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= bitcamp.dist %>/index.html"
          "<%= bitcamp.tmp %>/**/*.html"
          "<%= bitcamp.tmp %>/**/*.js"
          "<%= bitcamp.app %>/**/*.glsl"
        ]

      express:
        files: [ "<%= bitcamp.srv %>/**/*.coffee", "bitcamp.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn:    true

      css:
        files: ["<%= bitcamp.app %>/**/*.css"]
        tasks: [ "autoprefixer" ]

      gruntfile: files: ["Gruntfile.{js,coffee}"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= bitcamp.tmp %>/*"
            "<%= bitcamp.dist %>/*"
            "!<%= bitcamp.dist %>/bower_components"
          ]
        ]


    jade:
      index:
        expand: true
        cwd:    "<%= bitcamp.app %>"
        src:    [ "index.jade" ]
        dest:   "<%= bitcamp.dist %>"
        ext:    ".html"
      templates:
        expand: true
        cwd:    "<%= bitcamp.app %>"
        src:    [ "**/*.jade", "!index.jade" ]
        dest:   "<%= bitcamp.tmp %>"
        ext:    ".html"


    autoprefixer:
      options: browsers: ["last 1 version"]
      dist:
        expand: true
        cwd:    "<%= bitcamp.tmp %>"
        src:    [ "**/*.css" ]
        dest:   "<%= bitcamp.tmp %>"


    coffee:
      dist:
        options: sourceMap: false
        files: [
          expand: true
          cwd:  "<%= bitcamp.app %>"
          src:  "**/*.coffee"
          dest: "<%= bitcamp.tmp %>"
          ext: ".js"
        ]
      dev:
        options:
          sourceMap: true
          sourceRoot: ""
        files: "<%= coffee.dist.files %>"


    compass:
      options:
        sassDir:                 "<%= bitcamp.app %>"
        cssDir:                  "<%= bitcamp.tmp %>"
        imagesDir:               "<%= bitcamp.app %>"
        javascriptsDir:          "<%= bitcamp.app %>"
        fontsDir:                "<%= bitcamp.app %>"
        importPath:              "<%= bitcamp.app %>/bower_components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      prod: options: debugInfo: false
      dev:  options: debugInfo: true
      watch:
        debugInfo: false
        watch:     true


    useminPrepare:
      options: dest: "public"
      html: "<%= bitcamp.dist %>/index.html"


    usemin:
      options:
        assetsDirs: [
          "<%= bitcamp.dist %>"
          "!<%= bitcamp.dist %>/bower_components"
        ]
      html:
        expand: true
        cwd: "<%= bitcamp.dist %>"
        src: [
          "**/*.html"
          "!bower_components/**"
        ]
        dest: "<%= bitcamp.dist %>"
      css:
        expand: true
        cwd: "<%= bitcamp.dist %>"
        src: [
          "**/*.css"
          "!bower_components/**"
        ]
        dest: "<%= bitcamp.dist %>"


    usebanner:
      options:
        position: "top"
        banner: require "./ascii"
      files:  [ "<%= bitcamp.dist %>/index.html" ]


    ngAnnotate:
      dist:
        expand: true
        cwd:  "<%= bitcamp.tmp %>"
        src:  "**/*.js"
        dest: "<%= bitcamp.tmp %>"


    copy:
      components_dist:
        expand: true
        cwd: "<%= bitcamp.app %>"
        src:  [ "bower_components/**" ]
        dest: "<%= bitcamp.dist %>"
      app_dist:
        expand: true
        cwd: "<%= bitcamp.app %>"
        dest: "<%= bitcamp.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
          "main/**/*.glsl"
        ]


    inject:
      googleAnalytics:
        scriptSrc: "<%= bitcamp.app %>/ga.js"
        files:
          "<%= bitcamp.dist %>/index.html": "<%= bitcamp.dist %>/index.html"


    concurrent:
      dist1_dev: [
        "compass:dev"
        "coffee:dev"
      ]
      dist1: [
        "jade"
        "compass:prod"
        "coffee:dist"
      ]
      dist2: [
        "ngAnnotate"
        "autoprefixer"
      ]
      dist3: [
        "copy:app_dist"
        "inject:googleAnalytics"
      ]
      watch:
        options: logConcurrentOutput: true
        tasks: [
          "watch"
          "compass:watch"
        ]


    ngtemplates:
      bitcampApp:
        cwd:  "<%= bitcamp.tmp %>"
        src:  [ "**/*.html", "!index.html" ]
        dest: "<%= bitcamp.dist %>/scripts/templates.js"
        options:
          usemin: "scripts/bitcamp.js"


    cdnify:
      options:
        cdn: cdnData
      dist:
        html: ['<%= bitcamp.dist %>/*.html']


    filerev:
      server:
        expand: true
        cwd: "<%= bitcamp.dist %>"
        src: [
          "**/*.css"
          "**/*.js"
          "!bower_components/**"
        ]
        dest: "<%= bitcamp.dist %>"



  grunt.registerTask "build", [
    "clean"

    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"
    "cdnify"

    "ngtemplates"
    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

    "filerev"

    "usemin"

    "concurrent:dist3"
    "usebanner"
  ]


  grunt.registerTask "express-keepalive", -> @async()


  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run [
        "build"
        "express:prod"
        "express-keepalive"
      ]
    else
      return grunt.task.run [
        "clean"

        "jade"
        "concurrent:dist1_dev"

        "prettify"

        "autoprefixer"
        "useminPrepare"

        "concurrent:dist2"

        "express:dev"

        "concurrent:watch"
      ]


  grunt.registerTask "default", [
    "build"
  ]

