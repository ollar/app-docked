define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'translate'], ($, _, Backbone, App, translate)->
  ListView = Backbone.View.extend
    className: 'pure-menu menu-wrapper'

    initialize: (options)->
      @options = options || {}
      @render()
      @subviews = []

    events:
      'change #sort': 'sortList'
      'click .add-new': 'addNew'
      'click .select-all': 'selectAll'
      'click .remove-all': 'destroyAll'

    sortList: (e)->
      _val = $(e.target).val()
      @collection.comparator = _val
      @collection.sort()

      _.each @subviews, (view)->
        view.remove()
      @renderData()

    addNew: (e) ->
      addView = new @addView({front_view: @view})
      @$list.prepend addView.render().el

    selectAll: ->
      _.each @subviews, (view)->
        view.trigger 'select'

    destroyAll: ->
      _.each @subviews, (view)->
        view.model.destroy()

    render: ->
      @options.content.html @$el
      @$el.html _.template(@listTemplate).call(@, {t: translate})

      @

    remove: ->
      bbRemove = _.after @subviews.length, =>
        Backbone.View.prototype.remove.apply(this, arguments)

      _.each @subviews, (view)->
        view.remove()
        bbRemove()

    renderData: ->
      @collection.each (model)->
        view = new @view({model: model})
        @subviews.push(view)
        @$list.append view.render(model.toJSON()).el
      , @

      @

  ListView
