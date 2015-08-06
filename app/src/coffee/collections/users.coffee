define [
  'jquery'
  'underscore'
  'backbone'
  'models/user'], ($, _, Backbone, UserModel)->
  UsersCollection = Backbone.Collection.extend
    model: UserModel

    url: '/user/'

    parse: (data, options)->
      return data.users

    initialize: (options)->
      @options = options || {}

    comparator: 'username'

  UsersCollection
