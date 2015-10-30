define [
  'app'
  'marionette'

  'text!templates/comment/view.html'

  'moment'
  'translate'
  'behaviors/select'
  'behaviors/setAttrs'
  'behaviors/link'
  ], (App, Mn, CommentTemplate, moment, translate, Select, SetAttrs, Link) ->
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
      Link:
        behaviorClass: Link
