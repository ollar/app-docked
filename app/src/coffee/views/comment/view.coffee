define [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'text!templates/comment/view.html'

  'moment'
  'translate'
  'behaviors/select'
  ], (App, $, _, Backbone, Mn, CommentTemplate, moment, translate, Select) ->
  CommentView = Mn.ItemView.extend
    className: 'comment pure-menu-item'

    template: _.template CommentTemplate
    templateHelpers: ->
      t: translate
      moment: moment

    behaviors:
      Select:
        behaviorClass: Select

    onRender: ->
      @$el.attr("id", "comment-id-" + @model.id)
