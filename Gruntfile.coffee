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
      coffee:
        files: ["<%= yeoman.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      compass:
        files: ["<%= yeoman.app %>/{,*//*}*.{scss,sass}"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      livereload_css:
        files: [ "<%= yeoman.tmp %>/**/*.css" ]
        options:
          livereload: true
      livereload_else:
        files: [
          "<%= yeoman.app %>/{,*//*}*.{html,jade}"
          "<%= yeoman.tmp %>/**/*.js"
          "<%= yeoman.app %>/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        options:
          livereload: true

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
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]


    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd:    "<%= yeoman.tmp %>/styles/"
          src:    "**/*.css"
          dest:   "<%= yeoman.tmp %>/styles/"
        ]


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
        generatedImagesDir:      "<%= yeoman.tmp %>/images/generated"
        imagesDir:               "<%= yeoman.app %>/images"
        javascriptsDir:          "<%= yeoman.app %>"
        fontsDir:                "<%= yeoman.app %>/fonts"
        importPath:              "bower_components"
        httpImagesPath:          "/images"
        httpGeneratedImagesPath: "/images/generated"
        httpFontsPath:           "/styles/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      server:
        options:
          debugInfo: true


    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/{,*/}*.js"
            "<%= yeoman.dist %>/styles/{,*/}*.css"
            "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
          ]


    useminPrepare:
      html: [
        "<%= yeoman.app %>/**/*.jade"
      ]
      options:
        dest: "<%= yeoman.dist %>"


    usemin:
      html: [
        "<%= yeoman.dist %>/**/*.html"
        "<%= yeoman.dist %>/**/*.jade"
      ]
      css: ["<%= yeoman.dist %>/**/*.css"]
      options:
        assetsDirs: ["<%= yeoman.dist %>"]


    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "**/*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]


    ngmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.tmp %>/concat"
          src: "**/*.js"
          dest: "<%= yeoman.tmp %>/concat"
        ]


    copy:
      dist:
        files: [
            expand: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "*.{ico,txt}"
              "images/**/*"
              "fonts/**/*"
              "static/**/*"
            ]
          ,
            expand: true
            cwd:  "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src:  [ "**/*.jade" ]
          ,
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: [ "generated/**/*" ]
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>"
        dest: "<%= yeoman.tmp %>"
        src: "**/*.css"


    concurrent:
      server: [
        "coffee:dist"
        "compass:server"
        "copy:styles"
      ]
      dist: [
        "coffee"
        "compass:dist"
        "copy:styles"
        "svgmin"
      ]


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
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngmin"
    "copy:dist"
    "cssmin"
    "uglify"
    "rev"
    "usemin"
  ]

  grunt.registerTask "default", [
    "build"
  ]
