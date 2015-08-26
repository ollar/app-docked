define [
  'app'
  'marionette'
  'translate'
], (App, Mn, translate)->
  Delete = Mn.Behavior.extend
    defaults:
      message: translate 'removed successfully'

    events:
      'click @ui.remove': 'removeMe'

    removeMe: ->
      @view.model.destroy
        success: =>
          App.execute 'message',
            text: @options.message
          @view.destroy()
          App.ventFunctions.updateLocalUser()
        error: (model, response, options)=>
          App.execute 'message', {type: response.responseJSON.type, text: translate response.responseJSON.text}


  Delete
