define [
  'marionette'
], (Mn) ->
  Select = Mn.Behavior.extend
    initialize: ->
      @view.select = no

      @view.on 'me:clicked', _.bind ()->
        @view.select = !@view.select
        @toggleSelect()
      , @

    triggers:
      'click': 'me:clicked'

    toggleSelect: ->
      @$el.toggleClass 'selected', @view.select

      @

  Select
