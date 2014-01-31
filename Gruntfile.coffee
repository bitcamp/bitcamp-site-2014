# Generated on 2013-12-20 using generator-angular-fullstack 1.0.1
"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->

  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt

  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    yeoman:

      # configurable paths
      app: require("./bower.json").appPath or "app"
      dist: "public"
      views: "views"

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
        files: ["<%= yeoman.app %>/scripts/{,*/}*.{coffee,litcoffee,coffee.md}"]
        tasks: ["newer:coffee:dist"]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      livereload_css:
        files: [
          "{.tmp,<%= yeoman.app %>}/styles/{,*//*}*.css"
        ]
        options:
          livereload: true
      livereload_else:
        files: [
          "<%= yeoman.app %>/<%= yeoman.views %>/{,*//*}*.{html,jade}"
          "{.tmp,<%= yeoman.app %>}/scripts/{,*//*}*.js"
          "<%= yeoman.app %>/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        options:
          livereload: true

      express:
        files: [
          "bitcamp.coffee"
          "lib/{,*//*}*.{coffee,js,json}"
        ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

      styles:
        files: ["<%= yeoman.app %>/styles/{,*/}*.css"]
        tasks: [
          "newer:copy:styles"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.js"]


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: []


    # Empties folders to start fresh
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

      heroku:
        files: [
          dot: true
          src: [
            "heroku/*"
            "!heroku/.git*"
            "!heroku/Procfile"
          ]
        ]

      server: ".tmp"


    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "{,*/}*.css"
          dest: ".tmp/styles/"
        ]


    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]


    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        generatedImagesDir: ".tmp/images/generated"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: "<%= yeoman.app %>/bower_components"
        httpImagesPath: "/images"
        httpGeneratedImagesPath: "/images/generated"
        httpFontsPath: "/styles/fonts"
        relativeAssets: false
        assetCacheBuster: false

      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      server:
        options:
          debugInfo: true


    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/{,*/}*.js"
            "<%= yeoman.dist %>/styles/{,*/}*.css"
            "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
          ]


    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: [
        "<%= yeoman.app %>/<%= yeoman.views %>/**/*.jade"
      ]
      options:
        dest: "<%= yeoman.dist %>"


    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: [
        "<%= yeoman.dist %>/<%= yeoman.views %>/{,*/}*.html"
        "<%= yeoman.dist %>/<%= yeoman.views %>/{,*/}*.jade"
      ]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        assetsDirs: ["<%= yeoman.dist %>"]


    # The following *-min tasks produce minified files in the dist folder
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
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        options: {}

        # Optional configurations that you can uncomment to use
        # removeCommentsFromCDATA: true,
        # collapseBooleanAttributes: true,
        # removeAttributeQuotes: true,
        # removeRedundantAttributes: true,
        # useShortDoctype: true,
        # removeEmptyAttributes: true,
        # removeOptionalTags: true*/
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/<%= yeoman.views %>"
          src: [
            "*.html"
            "partials/*.html"
          ]
          dest: "<%= yeoman.dist %>/<%= yeoman.views %>"
        ]


    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: "*.js"
          dest: ".tmp/concat/scripts"
        ]


    # Replace Google CDN references
    #cdnify: {
    #      dist: {
    #        html: ['<%= yeoman.views %>/*.html']
    #      }
    #    },

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "bower_components/**/*"
              "images/*"
              "fonts/*"
              "static/*"
            ]
          }
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>/<%= yeoman.views %>"
            dest: "<%= yeoman.dist %>/<%= yeoman.views %>"
            src: "**/*.jade"
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: ["generated/*"]
          }
        ]

      heroku:
        files: [
          {
            expand: true
            dot: true
            dest: "heroku"
            src: [
              "<%= yeoman.dist %>/**"
            ]
          }, {
            expand: true
            dest: "heroku"
            src: [
              "package.json"
              "server.coffee"
              "lib/**/*"
            ]
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"


    # Run some tasks in parallel to speed up the build process
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
        #"imagemin"
        "svgmin"
        "htmlmin"
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
      "clean:server"
      "concurrent:server"
      "autoprefixer"
      "express:dev"
      "watch"
    ]

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]

  grunt.registerTask "build", [
    "clean:dist"
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngmin"
    "copy:dist"
    #'cdnify',
    "cssmin"
    "uglify"
    "rev"
    "usemin"
  ]
  grunt.registerTask "heroku", [
    "build"
    "clean:heroku"
    "copy:heroku"
  ]
  grunt.registerTask "default", [
    "newer:jshint"
    "build"
  ]
