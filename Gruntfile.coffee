templatizer = require 'templatizer'

module.exports = (grunt) ->

  #load tasks
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-concurrent')
  grunt.loadNpmTasks('grunt-nodemon')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-coffeeify')

  #load config
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compileServer:
        expand: yes
        cwd: 'src/server'
        src: ['**/*.coffee']
        dest: 'dist/server/'
        ext: '.js'

    coffeeify:
      client:
        files: [
            src: ['src/app/scripts/**/*.coffee','src/app/scripts/**/*.js']
            dest: 'dist/public/scripts/openabr.js'
        ]

    copy:
      appAssets:
        expand: yes
        cwd: 'src/app/assets'
        src: ['fonts/**', 'img/**']
        dest: 'dist/public/assets'

    less:
      compile:
        options:
          cleancss: no
        files:
          "dist/public/assets/css/style.css": "src/app/assets/less/style.less"

    jade:
      compileIndex:
        options:
          pretty: yes
          client: no
        files:
          'dist/public/index.html': 'src/app/index.jade'

    clean:
      distribution: ['dist/**']
      scripts: ['dist/public/scripts']
      distPublic: ['dist/public/**']
      distServer: ['dist/server/**']

    watch:
      templates:
        files: ['src/app/templates/**']
        tasks: ['templatizer']
        options:
          spawn: false
      app:
        files: [
          'src/app/scripts/**'
          'src/app/assets/**'
          'src/app/index.jade'
        ]
        tasks: ['build:app']
        options:
          spawn: false
      server:
        files: ['src/server/**']
        tasks: ['build:server']
        options:
          spawn: false

    nodemon:
      developmentServer:
        script: 'dist/server/server.js'
        options:
          env:
            PORT: '8080'
          watch: 'dist/server'
          ext: '.js'
          delay: 1000

    connect:
      developmentApp:
        options:
          keepalive: yes
          port: 8081
          base: 'dist/public/'

    concurrent:
      options:
        logConcurrentOutput: yes
      development: [
        'watch:templates'
        'watch:app'
        'watch:server'
        'nodemon:developmentServer'
        'connect:developmentApp'
      ]

  grunt.registerTask 'templatizer', () ->
    sourceDirectory = 'src/app/templates'
    targetFile = 'src/app/scripts/templates.js'
    options = {}
    templatizer(sourceDirectory, targetFile, options)

  grunt.registerTask 'build:app', [
    'clean:distPublic'
    'coffeeify:client'
    'copy:appAssets'
    'less:compile'
    'jade:compileIndex'
  ]

  grunt.registerTask 'build:server', [
    'clean:distServer'
    'coffee:compileServer'
  ]

  grunt.registerTask 'build', ['build:server','build:app']

  grunt.registerTask 'dev', [
    'build'
    'concurrent:development'
  ]
