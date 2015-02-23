
#This is just a nice way to access all of the pages without cluttering.

#standard for naming, if it is an 'Acutal' class then capitalise first letter
#if it is a group then do not capitalise the first letter.
module.exports =

  Home: require './home.coffee'
  About: require './about.coffee'
  Contact: require './contact.coffee'
  Login: require './login.coffee'
  FourOhFour: require './404.coffee'
  FourOhOne: require './401.coffee'
  Status: require './status.coffee'
  upload:
    SelectData: require './upload/select-data.coffee'
    ThresholdAnalysis: require './upload/threshold-analysis.coffee'
    LatencyAnalysis: require './upload/latency-analysis.coffee'
    ReviewAndCommit: require './upload/review-and-commit.coffee'
  admin:
    users:
      Users: require './admin/users/users.coffee'
      Create: require './admin/users/create.coffee'
      Edit: require './admin/users/edit.coffee'
      Password: require './admin/users/password.coffee'
    fields:
      Index: require './admin/fields/index.coffee'
      List: require './admin/fields/list.coffee'
      CreateDataField: require './admin/fields/create-data-field.coffee'
      EditDataField: require './admin/fields/edit-data-field.coffee'
  profile:
    View: require './profile/view.coffee'
    Edit: require './profile/edit.coffee'
    ChangePassword: require './profile/change-password.coffee'
  subjects:
    Index: require './subjects/index.coffee'
    Create: require './subjects/create.coffee'
    Edit: require './subjects/edit.coffee'
    View: require './subjects/view.coffee'
    Remove: require './subjects/remove.coffee'
  experiments:
    Index: require './experiments/index.coffee'
    Create: require './experiments/create.coffee'
    Edit: require './experiments/edit.coffee'
    View: require './experiments/view.coffee'
    Remove: require './experiments/remove.coffee'
  query:
    Readings: require './query/readings.coffee'
    Sets: require './query/sets.coffee'
    Groups: require './query/groups.coffee'
  abrReadings:
    View: require './abr-readings/view.coffee'
    Remove: require './abr-readings/remove.coffee'
    Edit: require './abr-readings/edit.coffee'
  abrGroups:
    View: require './abr-groups/view.coffee'
    Remove: require './abr-groups/remove.coffee'
    Edit: require './abr-groups/edit.coffee'
  abrSets:
    View: require './abr-sets/view.coffee'
    Remove: require './abr-sets/remove.coffee'
    Edit: require './abr-sets/edit.coffee'
