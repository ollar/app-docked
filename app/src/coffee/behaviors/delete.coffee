define [
  'app'
  'marionette'
], (App, Mn)->
  Delete = Mn.Behavior.extend
    defaults:
      text: 'Removed successfully'

    events:
      'click @ui.removeButton': 'removeMe'

    removeMe: ->
      console.log @options
      # @view.model.destroy
      #   success: ->
      #     App.execute 'message',
      #       text: @options.text


  Delete
