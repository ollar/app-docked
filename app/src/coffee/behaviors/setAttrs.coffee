define [
  'marionette'
], (Mn)->
  SetAttrs = Mn.Behavior.extend
    initialize: (options)->
      @options = options || {}

    onRender: ->
      @$el.attr 'data-id', @view.model.id
      _.each @options.attrs, (value, key)=>
        @$el.attr 'data-'+key, @view.model.get(value)

  SetAttrs
