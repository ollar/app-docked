define ['backbone'], (Backbone)->
  UserModel = Backbone.Model.extend

    urlRoot: '/user/'

    defaults: ->
      username: ''
      real_name: ''
      email: ''

  UserModel
