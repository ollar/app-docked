define [
  'marionette'
], (Mn) ->
  Paginate = Mn.Behavior.extend
    initialize: ->
      @page = 1
      @collectionUrl = @view.collection.url

    ui:
      next: '.pagination .next'
      prev: '.pagination .prev'
      current: '.pagination .current'

    events:
      'click @ui.next': 'nextClicked'
      'click @ui.prev': 'prevClicked'

    generateUrl: (page)->
      @page = page
      @collectionUrl + _.template('?page=<%= page %>')({page: page})

    nextClicked: ->
      return if @view.collection.length < 10
      @view.collection.url = @generateUrl(@page+1)

      @view.collection.fetch
        success: ()=>
          @view.render()
          @ui.current.html @page

    prevClicked: ->
      return if @page <= 1
      @view.collection.url = @generateUrl(@page-1)

      @view.collection.fetch
        success: ()=>
          @view.render()
          @ui.current.html @page

  Paginate
