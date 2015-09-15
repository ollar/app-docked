define [
  'marionette'
], (Mn)->
  InfScroll = Mn.Behavior.extend
    initialize: ->
      @busy = no
      @page = 1
      @collectionUrl = @view.collection.url.split('?')[0]
      @view.collection.url = @generateUrl(@page)
      @view.reorderOnSort = no

      @winHeight = $(window).height()

    events:
      'scroll': -> console.log 'scroll'

    generateUrl: (page)->
      @page = page
      @collectionUrl + _.template('?page=<%= page %>&limit=10')({page: page})

    isBottom: ->
      @view.el.getBoundingClientRect().bottom <= @winHeight + 200

    onRender: ->
      $(document).on 'scroll', _.debounce =>
          if @isBottom() and !@busy
            @nextClicked()
        , 200

        return

    onDestroy: ->
      $(document).off 'scroll'

    nextClicked: ->
      @busy = yes
      new_items = new Backbone.Collection()
      new_items.url = @generateUrl(@page+1)
      new_items.parse = (data)->
        _.values(data).pop()

      new_items.fetch
        success: (collection)=>
          return if collection.length == 0
          @view.collection.add(collection.models)
          @busy = no

  InfScroll
