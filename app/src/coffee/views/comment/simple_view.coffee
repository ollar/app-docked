define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'moment'

  'text!templates/comment/simple_view.html'
], (App, $, _, Mn, moment, CommentTemplate) ->
  CommentSimpeView = Mn.ItemView.extend
    className: 'simple comment'
    template: _.template CommentTemplate
    initialize: (options)->
      @options = options || {}
    templateHelpers: ->
      moment: moment
      origin: @options.origin

  CommentSimpeView
