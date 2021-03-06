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

    'query': 'queryReadings'
    'query/readings': 'queryReadings'
    'query/sets': 'querySets'
    'query/groups': 'queryGroups'

    'abr/readings/:id/view': 'abrReadingView'
    'abr/readings/:id/edit': 'abrReadingEdit'
    'abr/readings/:id/remove': 'abrReadingRemove'

    'abr/sets/:id/view': 'abrSetView'
    'abr/sets/:id/edit': 'abrSetEdit'
    'abr/sets/:id/remove': 'abrSetRemove'

    'abr/groups/:id/view': 'abrGroupView'
    'abr/groups/:id/edit': 'abrGroupEdit'
    'abr/groups/:id/remove': 'abrGroupRemove'

    'experiments': 'experiments'
    'treatments': 'experiments'
    'experiments/create': 'experimentCreate'
    'experiments/:id/edit': 'experimentEdit'
    'experiments/:id/view': 'experimentView'
    'experiments/:id/remove': 'experimentRemove'

    'subjects': 'subjects'
    'patients': 'subjects'
    'subjects/create': 'subjectCreate'
    'subjects/:id/edit': 'subjectEdit'
    'subjects/:id/view': 'subjectView'
    'subjects/:id/remove': 'subjectRemove'

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

  #query routes
  queryReadings: () -> @.showUserPage new pages.query.Readings()
  querySets: () -> @.showUserPage new pages.query.Sets()
  queryGroups: () -> @.showUserPage new pages.query.Groups()

  #abr reading
  abrReadingView: (id) -> @.showUserPage new pages.abrReadings.View({id})
  abrReadingEdit: (id) -> @.showUserPage new pages.abrReadings.Edit({id})
  abrReadingRemove: (id) -> @.showUserPage new pages.abrReadings.Remove({id})

  #abr set
  abrSetView: (id) -> @.showUserPage new pages.abrSets.View({id})
  abrSetEdit: (id) -> @.showUserPage new pages.abrSets.Edit({id})
  abrSetRemove: (id) -> @.showUserPage new pages.abrSets.Remove({id})

  #abr group
  abrGroupView: (id) -> @.showUserPage new pages.abrGroups.View({id})
  abrGroupEdit: (id) -> @.showUserPage new pages.abrGroups.Edit({id})
  abrGroupRemove: (id) -> @.showUserPage new pages.abrGroups.Remove({id})

  #subject routes
  subjects: () -> @.showUserPage new pages.subjects.Index()
  subjectCreate: () -> @.showUserPage new pages.subjects.Create()
  subjectEdit: (id) -> @.showUserPage new pages.subjects.Edit({id})
  subjectView: (id) -> @.showUserPage new pages.subjects.View({id})
  subjectRemove: (id) -> @.showUserPage new pages.subjects.Remove({id})

  #experiment routes
  experiments: () -> @.showUserPage new pages.experiments.Index()
  experimentCreate: () -> @.showUserPage new pages.experiments.Create()
  experimentEdit: (id) -> @.showUserPage new pages.experiments.Edit({id})
  experimentView: (id) -> @.showUserPage new pages.experiments.View({id})
  experimentRemove: (id) -> @showUserPage new pages.experiments.Remove({id})

  #Catch all other routes and head back to home
  catchAll: () ->
    @.showPage new pages.FourOhFour()