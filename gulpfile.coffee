gulp = require('gulp-help')(require('gulp'))

config = require 'config'
couchPush = require 'couchdb-push'
notifier = require 'node-notifier'
path = require 'path'
watch = require 'gulp-watch'

#folders for app
app =
  src: path.resolve __dirname, "./app"
  bin: path.resolve __dirname, "./bin/app"

#folder for login (fixed, is not built like the app)
login =
  src: path.resolve __dirname, "./login"

admin =
  src: path.resolve __dirname, "./admin"
  bin: path.resolve __dirname, "./bin/admin"

#main functions
gulp.task "watch", ['watch-app', 'watch-login', 'watch-admin']
gulp.task "build", ["build-app"]

#Login
gulp.task "dev-deploy-login", (callback) ->
  notifier.notify({title: "login deployment", message: "starting login deployment"})

  #create database target with authentication in the string (basic couchdb authentication)
  targetdb = "#{config.couchdb.host}:#{config.couchdb.port}/#{config.openabr.logindb}"
  targetdb = targetdb.replace("http://", "http://#{config.couchdb.username}:#{config.couchdb.password}@")
  couchPush targetdb, login.src, {multipart: yes}, (err, resp) ->
    if err?
      console.log "Unexpected error trying to deploy 'login' to #{targetdb}"
      return callback(err)

    notifier.notify({title: "login deployment", message: "login deployed to #{targetdb}"})
    callback(null)

gulp.task "watch-login", () ->
  watch "#{login.src}/**/*", () -> gulp.start("dev-deploy-login")

#Admin
gulp.task "dev-deploy-admin", (callback) ->
  notifier.notify({title: "admin deployment", message: "starting admin deployment"})

  #create database target with authentication in the string (basic couchdb authentication)
  targetdb = "#{config.couchdb.host}:#{config.couchdb.port}/#{config.openabr.admindb}"
  targetdb = targetdb.replace("http://", "http://#{config.couchdb.username}:#{config.couchdb.password}@")
  couchPush targetdb, admin.src, {multipart: yes}, (err, resp) ->
    if err?
      console.log "Unexpected error trying to deploy 'admin' to #{targetdb}"
      return callback(err)

    notifier.notify({title: "admin deployment", message: "admin deployed to #{targetdb}"})
    callback(null)

gulp.task "watch-admin", () ->
  watch "#{admin.src}/**/*", () -> gulp.start("dev-deploy-admin")

#App
gulp.task "build-app", () ->
  console.log 'nichts' #TODO

gulp.task "dev-deploy-app", ["build-app"], (callback) ->
  notifier.notify({title: "app deployment", message: "starting app deployment"})

  #create database target with authentication in the string (basic couchdb authentication)
  targetdb = "#{config.couchdb.host}:#{config.couchdb.port}/#{config.openabr.appdb}"
  targetdb = target.replace("http://", "http://#{config.couchdb.username}:#{config.couchdb.password}@")
  couchPush targetdb, app.bin, {multipart: yes}, (err, resp) ->
    if err?
      console.log "Unexpected error trying to deploy 'app' to #{targetdb}"
      return callback(err)

    notifier.notify({title: "app deployment", message: "app deployed to #{targetdb}"})
    callback(null)

gulp.task "watch-app", () ->
  watch "#{app.src}/**/*", () -> gulp.start("dev-deploy-app")

#deployment function
gulp.task "deploy", () ->
  console.log "todo" #TODO this
  #Build everything

  #ask questions about target, login details etc

  #if target db already exists check version document in each

  #ask if they are sure they want to upgrade if version same or greater than

  #if version is less show error message and exist

  #push databases
