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

      compileApp:
        bare: yes
        expand: yes
        cwd: 'src/app/scripts'
        src: ['**/*.coffee']
        dest: 'dist/public/scripts'
        ext: '.js'

    copy:
      appAssets:
        expand: yes
        cwd: 'src/app/assets'
        src: ['fonts/**', 'img/**']
        dest: 'dist/public/assets'

      appJavascripts:
        expand: yes
        cwd: 'src/app/scripts'
        src: ['**/*.js']
        dest: 'dist/public/scripts'

    less:
      compile:
        options:
          cleancss: no
        files:
          "dist/public/assets/css/style.css": "src/app/assets/less/style.less"

    jade:
      compileTemplates:
        options:
          client: yes
          processName: (filename) ->
            return filename
              .replace(new RegExp('src/app/templates/'), '')
              .replace(new RegExp('.jade'), '')
        files:
          'dist/public/scripts/templates.js': 'src/app/templates/**/*.jade'

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
      app:
        files: ['src/app/**']
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
        'watch:app'
        'watch:server'
        'nodemon:developmentServer'
        'connect:developmentApp'
      ]


  grunt.registerTask 'build:app', [
    'clean:distPublic'
    'coffee:compileApp'
    'copy:appAssets'
    'copy:appJavascripts'
    'less:compile'
    'jade:compileTemplates'
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
