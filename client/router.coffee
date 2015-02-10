Router = require 'ampersand-router'

pages = require './pages/index.coffee'

module.exports = Router.extend

  routes:
    '': 'home'
    'about': 'about'
    'contact': 'contact'
    'login': 'login'
    'logout': 'logout'
    '404': 'catchAll'
    '401': 'unauthorized'

    'profile': 'profile'
    'profile/edit': 'editProfile'
    'profile/change-password': 'changePassword'

    'admin/users': 'adminUsers'
    'admin/users/create': 'adminUserCreate'
    'admin/users/:userId/edit': 'adminUserEdit'

    'admin/fields': 'adminFields'
    'admin/fields/:col': 'adminFieldsList'
    'admin/fields/:col/create': 'adminFieldCreate'
    'admin/fields/:col/:dbName/edit': 'adminFieldEdit'

    'upload': 'uploadSelectData'

    'query': 'query'

    'experiments': 'experiments'
    'treatments': 'experiments'
    'experiments/create': 'experimentCreate'
    'experiments/:id/edit': 'experimentEdit'

    'subjects': 'subjects'
    'patients': 'subjects'
    'subjects/create': 'subjectCreate'
    'subjects/:id/edit': 'subjectEdit'
    'subjects/:id/view': 'subjectView'

    '(*path)': 'catchAll'

  #helpers
  showPage: (page) -> @.trigger 'page', page
  showUserPage: (page) -> if app.me.isLoggedIn then @.showPage page else do @.login
  showAdminPage: (page) -> if app.me.isAdmin then @.showUserPage page else do @.unauthorized

  #Basic route handlers
  about: () -> @.showPage new pages.About()
  contact: () -> @.showPage new pages.Contact()
  login: () -> @.showPage new pages.Login()
  unauthorized: () -> @.showPage new pages.FourOhOne()
  home: () ->
    if app.me.isLoggedIn
      @.showUserPage new pages.Status()
    else
      @.showPage new pages.Home()
  logout: () ->
    app.logout()
    @.showPage new pages.Home()

  #profile handlers
  profile: () ->
    console.log app.me.user
    @.showUserPage new pages.profile.View(model: app.me.user)

  editProfile: () ->
    @.showUserPage new pages.profile.Edit(model: app.me.user)

  changePassword: () ->
    @.showUserPage new pages.profile.ChangePassword(model: app.me.user)

  #Admin routes
  adminUsers: () -> @.showAdminPage new pages.admin.users.Users()
  adminUserCreate: () -> @.showAdminPage new pages.admin.users.Create()
  adminUserEdit: (user) -> @.showAdminPage new pages.admin.users.Edit({user})
  adminUserPassword: (passwordState) ->
    @.showAdminPage new pages.admin.users.Password(model: passwordState)

  adminFields: () -> @.showAdminPage new pages.admin.fields.Index()
  adminFieldsList: (col) -> @.showAdminPage new pages.admin.fields.List({col})
  adminFieldCreate: (col) -> @.showAdminPage new pages.admin.fields.CreateDataField({col})
  adminFieldEdit: (col, dbName) -> @.showAdminPage new pages.admin.fields.EditDataField({col,dbName})

  #Upload routes - only first should be nav-able with url
  uploadSelectData: () -> @.showUserPage new pages.upload.SelectData()
  uploadThresholdAnalysis: (uploadModel) -> @.showUserPage new pages.upload.ThresholdAnalysis(model: uploadModel)
  uploadLatencyAnalysis: (uploadModel) -> @.showUserPage new pages.upload.LatencyAnalysis(model: uploadModel)
  uploadReviewAndCommit: (uploadModel) -> @.showUserPage new pages.upload.ReviewAndCommit(model: uploadModel)


  query: () -> console.log 'Query route hit'

  #subject routes
  subjects: () -> @.showUserPage new pages.subjects.Index()
  subjectCreate: () -> @.showUserPage new pages.subjects.Create()
  subjectEdit: (id) -> @.showUserPage new pages.subjects.Edit({id})
  subjectView: (id) -> @.showUserPage new pages.subjects.View({id})

  #experiment routes
  experiments: () -> @.showUserPage new pages.experiments.Index()
  experimentCreate: () -> @.showUserPage new pages.experiments.Create()
  experimentEdit: (id) -> @.showUserPage new pages.experiments.Edit({id})

  #Catch all other routes and head back to home
  catchAll: () ->
    @.showPage new pages.FourOhFour()