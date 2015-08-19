define [
  'app'
  'marionette'
], (App, Mn)->
  Delete = Mn.Behavior.extend
    defaults:
      message: 'Removed successfully'

    events:
      'click @ui.removeButton': 'removeMe'

    removeMe: ->
      @view.model.destroy
        success: =>
          App.execute 'message',
            text: @options.message


  Delete
