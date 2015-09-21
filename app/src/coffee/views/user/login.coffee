define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/user/login.html'
  'translate'
  ], ($, _, App, Mn, LoginTemplate, translate) ->

  LoginView = Mn.ItemView.extend

    className: "login-form"

    template: _.template(LoginTemplate)
    templateHelpers: ->
      t: translate

    events:
      'submit #login_form': 'submitForm'

    initialize: (options)->
      @options = options || {}

    loginUser: (data)->
      $.cookie 'id', data.id
      $.cookie 'access_token', data.token

      App.ventFunctions.updateLocalUser ->
        App.execute 'message',
          text: translate 'welcome username', data.username

        App.navigate ''

    submitForm: (e)->
      e.preventDefault()

      formData = $(e.target).serializeObject()

      $.post '/user/login', JSON.stringify(formData), (data, status, xhr)=>
        @loginUser(data)

  LoginView
