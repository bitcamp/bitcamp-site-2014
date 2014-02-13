module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  grunt.initConfig
    bitcamp:

      app:   "client"
      srv:   "server"

      tmp:   ".tmp"
      dist:  "public"


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
        ]

      express:
        files: [ "<%= bitcamp.srv %>/**/*.coffee", "bitcamp.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn:    true

      css:
        files: ["<%= bitcamp.app %>/**/*.css"]
        tasks: [ "newer:copy:styles_tmp", "autoprefixer" ]

      gruntfile: files: ["Gruntfile.{js,coffee}"]


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
        importPath:              "components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      prod: options: debugInfo: false
      dev:  options: debugInfo: true
      watch:
        debugInfo: false
        watch:     true


    rev:
      dist:
        src: [
          "<%= bitcamp.dist %>/**/*.js"
          "<%= bitcamp.dist %>/**/*.css"
          "<%= bitcamp.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
          "!<%= bitcamp.dist %>/**/opengraph.png"
        ]


    useminPrepare:
      options: dest: "public"
      html: "<%= bitcamp.dist %>/index.html"


    usemin:
      options: assetsDirs: "<%= bitcamp.dist %>"
      html: [ "<%= bitcamp.dist %>/**/*.html" ]
      css:  [ "<%= bitcamp.dist %>/**/*.css" ]


    usebanner:
      options:
        position: "top"
        banner: require "./ascii"
      files:  [ "<%= bitcamp.dist %>/index.html" ]


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


    inject:
      googleAnalytics:
        scriptSrc: "<%= bitcamp.tmp %>/ga.js"
        files:
          "<%= bitcamp.dist %>/index.html": "<%= bitcamp.dist %>/index.html"


    concurrent:
      dist1_dev: [
        "compass:dev"
        "coffee:dev"
        "copy:styles_tmp"
      ]
      dist1: [
        "jade"
        "compass:prod"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist2: [
        "ngmin"
        "autoprefixer"
      ]
      dist3: [
        "copy:app_dist"
        "copy:components_dist"
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
          usemin: "scripts/main.js"



  grunt.registerTask "build", [
    "clean"

    "jade"
    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"

    "ngtemplates"
    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

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

