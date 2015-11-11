define [
  'app'
  'backbone'
], (App, Backbone)->
  UserDetailsModel = Backbone.Model.extend
    url: App.url '/user/details'

    defaults:
      username: ''
      real_name: ''
      email: ''
      comments: []
      orders: []

  UserDetailsModel
