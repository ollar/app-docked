define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  # 'channel'
  'text!templates/user/login.html'
  'models/loggedUser'
  'translate'], ($, _, Backbone, App, Mn, LoginTemplate, LoggedUserModel, translate) ->

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

      # channel.trigger 'localUser:create', data
      # channel.trigger 'message',
      #   text: 'Welcome, <b>'+data.username+'</b>'

      App.navigate '', yes

    submitForm: (e)->
      e.preventDefault()

      formData = $(e.target).serializeObject()

      $.post '/user/login', JSON.stringify(formData), (data, status, xhr)=>
        @loginUser(data)

  LoginView
