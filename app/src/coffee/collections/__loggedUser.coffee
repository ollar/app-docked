define (require)->
  LoggedUserModel = require('models/loggedUser')
  _localStorage = require('localStorage')

  LoggedUserCollection = Backbone.Collection.extend
    model: LoggedUserModel
    localStorage: new _localStorage("LoggedUser")


  LoggedUserCollection
