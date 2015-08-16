define [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'text!templates/comment/view.html'

  'moment'
  'translate'], (App, $, _, Backbone, Mn, CommentTemplate, moment, translate) ->
  CommentView = Mn.ItemView.extend
    className: 'comment pure-menu-item'

    template: _.template CommentTemplate
    templateHelpers: ->
      t: translate
      moment: moment

    onRender: ->
      @$el.attr("id", "comment-id-" + @model.id)
