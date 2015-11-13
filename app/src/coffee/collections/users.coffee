define [
  'app'
  'backbone'
  'models/user'
], (App, Backbone, UserModel)->
  UsersCollection = Backbone.Collection.extend
    model: UserModel

    url: App.url '/user/'

    parse: (data, options)->
      return data.users

    initialize: (options)->
      @options = options || {}

    comparator: 'username'

  UsersCollection
