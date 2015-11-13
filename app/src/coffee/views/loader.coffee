define ['backbone'], (Backbone)->
  Loader = Backbone.View.extend
    className: 'loader'

    initialize: ->
      @wrapper = $('#main-wrapper')
      @render()

    render: ->
      @wrapper.append(@$el)
      @$el.fadeIn()
      @

  Loader
