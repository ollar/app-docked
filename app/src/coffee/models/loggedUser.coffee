define [
  'backbone'
  'localStorage'], (Backbone)->
  LoggedUserModel = Backbone.Model.extend
    localStorage: new Backbone.LocalStorage("LoggedUser")
    defaults: ->
      id: 0
      username: ''
      real_name: ''

  LoggedUserModel
