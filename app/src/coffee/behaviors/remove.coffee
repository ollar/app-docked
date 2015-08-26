define [
  'app'
  'marionette'
], (App, Mn)->
  Delete = Mn.Behavior.extend
    defaults:
      command: ''
      message: 'Removed successfully'

    events:
      'click @ui.remove': 'removeMe'

    removeMe: ->
      _id = @view.model.id
      App.execute @options.command, _id, null, null
      # @view.model.destroy
      #   success: =>
      #     App.execute 'message',
      #       text: @options.message
      #     @view.destroy()
      #     App.ventFunctions.updateLocalUser()
      #   error: (model, response, options)=>
      #     App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}



  Delete
