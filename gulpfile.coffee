gulp = require('gulp-help')(require('gulp'))

config = require 'config'
couchPush = require 'couchdb-push'
notifier = require 'node-notifier'
path = require 'path'
watch = require 'gulp-watch'

es = require 'event-stream'
webpack = require 'webpack'
gutil = require 'gulp-util'
jade = require 'gulp-jade'

#Folders for user-portal and admin-portal
userPortal =
  src: path.resolve __dirname, "./user-portal"
  bin: path.resolve __dirname, "./bin/user-portal"

adminPortal =
  src: path.resolve __dirname, "./admin-portal"
  bin: path.resolve __dirname, "./bin/admin-portal"

#main application and database build function
buildApplication = (source, bin, filename, callback) ->
  designDocument = gulp.src("#{source}/design-document/**/*")
      .pipe(gulp.dest(bin))

  index = gulp.src("#{source}/index.jade")
    .pipe(jade({locals: {}, pretty: yes}))
    .pipe(gulp.dest("#{bin}/_attachments/statics"))

  es.merge(designDocument,index).on 'end', () ->

    #Configuration of webpack
    webpackConfig =
      cache: true
      devtool: 'source-map'
      entry:
        preload: "#{source}/app/app.coffee"
      output:
        path: "#{bin}/_attachments/statics/js"
        publicPath: '',
        filename: filename
      module:
        loaders: [
          { test: /\.coffee$/, loader: "coffee" },
          { test: /\.jade$/, loader: 'jade'},
          { test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' }
        ]
      resolve:
        extensions: ["", ".web.coffee", ".web.js", ".coffee", ".js", ".pug", ".css", ".styl"]

    #Exceuting webpack
    webpack webpackConfig, (err, stats) ->
      if err?
        gutil.log err
      else
        gutil.log("[build-#{filename}]", stats.toString({colors: true}))
        callback()

  return null

#main development deploy function
deployApplication = (name, bin, callback) ->
  notifier.notify({title: "#{name}-portal deployment", message: "starting #{name}-portal deployment"})

  #create database target with authentication in the string (basic couchdb authentication)
  targetdb = "#{config.couchdb.host}:#{config.couchdb.port}/#{config.databases[name]}"
  targetdb = targetdb.replace("http://", "http://#{config.couchdb.username}:#{config.couchdb.password}@")
  couchPush targetdb, bin, {multipart: yes}, (err, resp) ->
    if err?
      console.log "Unexpected error trying to deploy #{name}-portal to #{targetdb}"
      return callback(err)

    notifier.notify({title: "#{name}-portal deployment", message: "#{name}-portal deployed to #{targetdb}"})
    callback(null)

#gulp tasks
gulp.task "watch", () ->
  watch "#{userPortal.src}/**/*", () -> gulp.start("dev-deploy-user-portal")
  watch "#{adminPortal.src}/**/*", () -> gulp.start("dev-deploy-admin-portal")

gulp.task "build", ["build-user-portal", "build-admin-portal"]
gulp.task "build-user-portal", (callback) -> buildApplication userPortal.src, userPortal.bin, 'openabr.js', callback
gulp.task "build-admin-portal", (callback) -> buildApplication adminPortal.src, adminPortal.bin, 'openabr-administration.js', callback

gulp.task "dev-deploy-user-portal", ["build-user-portal"], (callback) -> deployApplication 'user', userPortal.bin, callback
gulp.task "dev-deploy-admin-portal", ["build-admin-portal"], (callback) -> deployApplication 'admin', adminPortal.bin, callback

#deployment function
gulp.task "deploy", () ->
  console.log "todo" #TODO this
  #Build everything

  #ask questions about target, login details etc

  #if target db already exists check version document in each

  #ask if they are sure they want to upgrade if version same or greater than

  #if version is less show error message and exist

  #push databases
