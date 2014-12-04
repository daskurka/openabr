
#This is just a nice way to access all of the pages without cluttering.

#standard for naming, if it is an 'Acutal' class then capitalise first letter
#if it is a group then do not capitalise the first letter.
module.exports =

  Home: require './home.coffee'
  About: require './about.coffee'
  Contact: require './contact.coffee'
  Login: require './login.coffee'
  FourOhFour: require './404.coffee'
  admin:
    accounts:
      Accounts: require './admin/accounts/accounts.coffee'
      Create: require './admin/accounts/create.coffee'
      Edit: require './admin/accounts/edit.coffee'

    users:
      Users: require './admin/users/users.coffee'
      Create: require './admin/users/create.coffee'
      Edit: require './admin/users/edit.coffee'
