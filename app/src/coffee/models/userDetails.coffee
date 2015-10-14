define [
  'jquery'
  'underscore'
  'backbone'], ($, _, Backbone)->
  UserDetailsModel = Backbone.Model.extend
    url: '/user/details'

    defaults:
      username: ''
      real_name: ''
      email: ''
      comments: []
      orders: []

  UserDetailsModel
