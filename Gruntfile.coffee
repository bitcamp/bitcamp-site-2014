module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  grunt.initConfig
    bitcamp:

      app:   "client"
      srv:   "server"

      tmp:   ".tmp"
      dist:  "dist"


    express:
      options:
        cmd: "coffee"

      dev:
        options:
          script: "bitcamp.coffee"
          node_env: "development"
          port: process.env.PORT or 8000

      prod:
        options:
          script: "bitcamp.coffee"
          node_env: "production"
          port: process.env.PORT or 80


    prettify:
      dist:
        expand: true
        cwd:  "<%= bitcamp.dist %>"
        src:  "**/*.html"
        dest: "<%= bitcamp.dist %>"

    watch:
      jade:
        files: ["<%= bitcamp.app %>/**/*.jade"]
        tasks: [ "newer:jade:dist" ]

      coffee:
        files: ["<%= bitcamp.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      compass:
        files: ["<%= bitcamp.app %>/**/*.sass"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      livereload_css:
        options: livereload: true
        files: [ "<%= bitcamp.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= bitcamp.dist %>/**/*.html"
          "<%= bitcamp.tmp %>/**/*.js"
          "<%= bitcamp.app %>/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

      express:
        files: [ "<%= bitcamp.srv %>/**/*.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn:    true
          #Without this option specified express won't be reloaded

      styles:
        files: ["<%= bitcamp.app %>/**/*.css"]
        tasks: [
          "newer:copy:styles_tmp"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.js"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= bitcamp.tmp %>/*"
            "<%= bitcamp.dist %>/*"
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
        src:    "**/*.css"
        dest:   "<%= bitcamp.tmp %>"


    coffee:
      options:
        sourceMap: true
        sourceRoot: "<%= bitcamp.app %>"
      dist:
        files: [
          expand: true
          cwd:  "<%= bitcamp.app %>"
          src:  "**/*.coffee"
          dest: "<%= bitcamp.tmp %>"
          ext: ".js"
        ]


    compass:
      options:
        sassDir:                 "<%= bitcamp.app %>"
        cssDir:                  "<%= bitcamp.tmp %>"
        imagesDir:               "<%= bitcamp.app %>"
        javascriptsDir:          "<%= bitcamp.app %>"
        fontsDir:                "<%= bitcamp.app %>"
        importPath:              "components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      dist:   options: debugInfo: false
      server: options: debugInfo: true


    rev:
      dist:
        src: [
          "<%= bitcamp.dist %>/**/*.js"
          "<%= bitcamp.dist %>/**/*.css"
          "<%= bitcamp.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
          "!<%= bitcamp.dist %>/**/opengraph.png"
        ]


    useminPrepare:
      html: "<%= bitcamp.dist %>/**/*.html"


    usemin:
      options: assetsDirs: "<%= bitcamp.dist %>"
      html: [ "<%= bitcamp.dist %>/**/*.html" ]
      css:  [ "<%= bitcamp.dist %>/**/*.css" ]


    ngmin:
      dist:
        expand: true
        cwd:  "<%= bitcamp.tmp %>"
        src:  "**/*.js"
        dest: "<%= bitcamp.tmp %>"


    copy:
      styles_tmp:
        expand: true
        cwd:  "<%= bitcamp.app %>"
        src:  "**/*.css"
        dest: "<%= bitcamp.tmp %>"
      components_dist:
        expand: true
        src:  [ "components/**" ]
        dest: "<%= bitcamp.dist %>"
      app_dist:
        expand: true
        cwd: "<%= bitcamp.app %>"
        dest: "<%= bitcamp.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
        ]
      views_dist:
        expand: true
        cwd:  "<%= bitcamp.tmp %>"
        dest: "<%= bitcamp.dist %>"
        src:  [ "**/*.html", "!index.html" ]


    inject:
      googleAnalytics:
        scriptSrc: "<%= bitcamp.tmp %>/ga.js"
        "<%= bitcamp.dist %>/index.html": "<%= bitcamp.dist %>/index.html"


    ngtemplates:
      bitcampTemplates:
        cwd:  "<%= bitcamp.tmp %>"
        src:  [ "**/*.html", "!index.html" ]
        dest: "<%= bitcamp.dist %>/scripts/templates.js"
        options:
          standalone: true
          usemin: "scripts/templates.js"


    concat:
      views_dist:
        src: [
          "<%= bitcamp.dist %>/**/*.html"
          "!<%= bitcamp.dist %>/index.html"
        ]
        dest: "<%= bitcamp.tmp %>/scripts/templates.html"


    html2js:
      options:
        base:   "dist"
        module: "bitcampTemplates"
      dev:
        expand: true
        src: "<%= bitcamp.tmp %>/**/*.html"
        ext: ".js"


    concurrent:
      dist1_dev: [
        "jade"
        "compass:server"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist1: [
        "jade"
        "compass:dist"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist2: [
        "ngmin"
        "autoprefixer"
      ]


  grunt.registerTask "build", [
    "clean"

    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"

    "ngtemplates"

    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

    "copy:views_dist"
    "concat:views_dist"

    "rev"

    "usemin"
    "copy:app_dist"
    "copy:components_dist"
    "inject:googleAnalytics"
  ]


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

        "concurrent:dist1_dev"

        "prettify"

        "autoprefixer"

        "html2js:dev"

        "express:dev"
        "express-keepalive"

        "watch"
      ]


  grunt.registerTask "default", [
    "build"
  ]


  grunt.registerTask "express-keepalive", "Keep grunt running", ->
    @async()

