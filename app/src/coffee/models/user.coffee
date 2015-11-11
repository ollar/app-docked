define [
  'app'
  'backbone'
], (App, Backbone)->
  UserModel = Backbone.Model.extend

    urlRoot: App.url '/user/'

    defaults: ->
      username: ''
      real_name: ''
      email: ''

  UserModel
