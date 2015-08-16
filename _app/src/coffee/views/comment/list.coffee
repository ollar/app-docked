define [
  'jquery'
  'underscore'
  'backbone'

  'models/user'
  'models/meal'

  'collections/users'
  'collections/meals'

  'text!templates/comment/view.html'
  'moment'
  'translate'
], ($, _, Backbone, UserModel, MealModel, UsersCollection, MealsCollection, ViewTemplate, moment, translate) ->

  class View extends Backbone.View
    tagName: 'ul'
    className: "pure-menu-list comments-list"

    events: {}

    initialize: (options)->
      super
      @content = options.content
      @ready = 0

      @render()

    template: _.template(ViewTemplate)

    render: ->
      _.each @collection.models, (comment)=>
        @$el.append @template(_.extend comment.toJSON(), {moment: moment, t: translate})

      @content.html @$el

      @
