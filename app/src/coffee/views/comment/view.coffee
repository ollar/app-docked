define [
  'app'
  'marionette'

  'text!templates/comment/view.html'

  'moment'
  'behaviors/select'
  'behaviors/setAttrs'
  'behaviors/link'
  ], (App, Mn, CommentTemplate, moment, Select, SetAttrs, Link) ->
  CommentView = Mn.ItemView.extend
    className: 'comment pure-menu-item'

    template: _.template CommentTemplate
    templateHelpers: ->
      moment: moment

    behaviors:
      Select:
        behaviorClass: Select
      SetAttrs:
        behaviorClass: SetAttrs
      Link:
        behaviorClass: Link
