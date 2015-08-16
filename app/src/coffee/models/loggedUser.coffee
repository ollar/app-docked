define [
  'jquery'
  'underscore'
  'backbone'
  'localStorage'], ($, _, Backbone)->
  LoggedUserModel = Backbone.Model.extend
    localStorage: new Backbone.LocalStorage("LoggedUser")
    defaults: ->
      id: 0
      username: ''
      real_name: ''

  LoggedUserModel
