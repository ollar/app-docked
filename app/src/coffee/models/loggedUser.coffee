define [
  'jquery'
  'underscore'
  'backbone'
  'localStorage'], ($, _, Backbone)->
  LoggedUserModel = Backbone.Model.extend
    localStorage: new Backbone.LocalStorage("LoggedUser")
    defaults: ->
      username: ''
      real_name: ''

  LoggedUserModel
