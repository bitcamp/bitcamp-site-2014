module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt

  grunt.initConfig

    yeoman:

      app:   "client"
      srv:   "server"
      dist:  "public"
      tmp:   ".tmp"


    express:
      options:
        port: process.env.PORT or 8000
        cmd: "coffee"

      dev:
        options:
          script: "bitcamp.coffee"
          node_env: "development"

      prod:
        options:
          script: "bitcamp.coffee"
          node_env: "production"


    watch:
      jade:
        files: ["<%= yeoman.app %>/**/*.jade"]
        tasks: [ "newer:jade:dist" ]

      coffee:
        files: ["<%= yeoman.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      compass:
        files: ["<%= yeoman.app %>/**/*.sass"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      livereload_css:
        options: livereload: true
        files: [ "<%= yeoman.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= yeoman.dist %>/**/*.html"
          "<%= yeoman.tmp %>/**/*.js"
          "<%= yeoman.app %>/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

      express:
        files: [ "<%= yeoman.srv %>/**/*.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

      styles:
        files: ["<%= yeoman.app %>/**/*.css"]
        tasks: [
          "newer:copy:styles"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.js"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= yeoman.tmp %>/*"
            "<%= yeoman.dist %>/*"
          ]
        ]


    jade:
      dist:
        options: pretty: true
        files: [
          expand: true
          cwd:    "<%= yeoman.app %>"
          src:    [ "**/*.jade", "!index.jade" ]
          dest:   "<%= yeoman.dist %>/views"
          ext:    ".html"
        ,
          expand: true
          cwd:    "<%= yeoman.app %>"
          src:    "index.jade"
          dest:   "<%= yeoman.dist %>"
          ext:    ".html"
        ]


    autoprefixer:
      options: browsers: ["last 1 version"]
      dist:
        expand: true
        cwd:    "<%= yeoman.tmp %>"
        src:    "**/*.css"
        dest:   "<%= yeoman.tmp %>"


    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          expand: true
          cwd:  "<%= yeoman.app %>"
          src:  "**/*.coffee"
          dest: "<%= yeoman.tmp %>"
          ext: ".js"
        ]


    compass:
      options:
        sassDir:                 "<%= yeoman.app %>"
        cssDir:                  "<%= yeoman.tmp %>"
        imagesDir:               "<%= yeoman.app %>/images"
        javascriptsDir:          "<%= yeoman.app %>"
        fontsDir:                "<%= yeoman.app %>/fonts"
        importPath:              "bower_components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      dist:   options: debugInfo: false
      server: options: debugInfo: true


    rev:
      dist:
        src: [
          "<%= yeoman.dist %>/**/*.js"
          "<%= yeoman.dist %>/**/*.css"
          "<%= yeoman.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
        ]


    useminPrepare:
      html: "<%= yeoman.dist %>/**/*.html"
      options: dest: "<%= yeoman.dist %>"

    usemin:
      html: [ "<%= yeoman.dist %>/**/*.html" ]
      css:  [ "<%= yeoman.dist %>/**/*.css" ]
      options: assetsDirs: "<%= yeoman.dist %>"

    imagemin:
      options:
        optimizationLevel: 7
        pngquant:          true
        progressive:       true
      dist:
        expand: true
        cwd:  "<%= yeoman.app %>"
        src:  "{,*//*}*.{png,jpg,jpeg,gif}"
        dest: "<%= yeoman.app %>"


    svgmin:
      dist:
        expand: true
        cwd: "<%= yeoman.dist %>"
        src: "**/*.svg"
        dest: "<%= yeoman.dist %>"


    ngmin:
      dist:
        expand: true
        cwd: "<%= yeoman.tmp %>"
        src: "**/*.js"
        dest: "<%= yeoman.tmp %>"


    copy:
      dist:
        expand: true
        cwd: "<%= yeoman.app %>"
        dest: "<%= yeoman.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
        ]

      styles:
        expand: true
        cwd:  "<%= yeoman.app %>"
        src:  "**/*.css"
        dest: "<%= yeoman.tmp %>"

      components:
        expand: true
        src:  [ "bower_components/**" ]
        dest: "<%= yeoman.dist %>"


    concurrent:
      server: [
        "coffee:dist"
        "compass:server"
        "jade:dist"
        "copy:styles"
      ]
      dist: [
        "coffee:dist"
        "compass:dist"
        "jade:dist"
        "copy:styles"
      ]

    prettify:
      dist:
        expand: true
        cwd:  "<%= yeoman.dist %>"
        src:  "**/*.html"
        dest: "<%= yeoman.dist %>"


  grunt.registerTask "express-keepalive", "Keep grunt running", ->
    @async()

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "express:prod"
        "express-keepalive"
      ])
    grunt.task.run [
      "clean"
      "concurrent:server"
      "autoprefixer"
      "express:dev"
      "watch"
    ]

  grunt.registerTask "build", [
    "clean"

    "concurrent:dist"

    "prettify:dist"
    "ngmin"
    "autoprefixer"

    "useminPrepare"

    "concat"
    "cssmin"
    "uglify"

    "copy:dist"
    "rev"

    "usemin"

    "copy:components"

    #"imagemin"
    "svgmin"
  ]

  grunt.registerTask "default", [
    "build"
  ]
