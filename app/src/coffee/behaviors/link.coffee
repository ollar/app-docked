define [
  'app'
  'jquery'
  'marionette'
], (App, $, Mn)->
  LinkBehavior = Mn.Behavior.extend
    events:
      'click a': 'linkClicked'

    linkClicked: (e)->
      e.preventDefault()
      App.navigate $(e.target).attr('href')

  LinkBehavior
