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
  'behaviors/setAttrs'
  ], (App, $, _, Backbone, Mn, CommentTemplate, moment, translate, Select, SetAttrs) ->
  CommentView = Mn.ItemView.extend
    className: 'comment pure-menu-item'

    template: _.template CommentTemplate
    templateHelpers: ->
      t: translate
      moment: moment

    behaviors:
      Select:
        behaviorClass: Select
      SetAttrs:
        behaviorClass: SetAttrs
