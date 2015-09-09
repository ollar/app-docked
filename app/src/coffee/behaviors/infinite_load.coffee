define [
  'marionette'
], (Mn)->
  InfScroll = Mn.Behavior.extend
    initialize: ->
      @page = 1
      @collectionUrl = @view.collection.url

    generateUrl: (page)->
      @page = page
      @collectionUrl + _.template('?page=<%= page %>')({page: page})

    nextClicked: ->
      return if @view.collection.length < 10
      @view.collection.url = @generateUrl(@page+1)

      @view.collection.fetch
        success: ()=>
          @view.render()

  InfScroll
