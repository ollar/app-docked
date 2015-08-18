define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/user/form.html'
  'models/user'
  'views/user/login'
  'translate'
  ], ($, _, App, Mn, userFormTemplate, UserModel, LoginView, translate)->
  UserFormView = Mn.ItemView.extend
    className: 'user-manage pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @model = @model || new UserModel()

    template: _.template(userFormTemplate)
    templateHelpers: ->
      t: translate

    events:
      'submit #user_form': 'updateUser'
      'click .cancel': 'cancelEdit'

    updateUser: (e)->
      e.preventDefault()
      formData = $(e.target).serializeObject()
      @model.save formData,
        success: (model, response, options)=>
          if model.get 'id' == $.cookie('id')
            App.vent.trigger 'localUser:update', model
          if @options.front_view
            userView = new @options.front_view {model: model}
            @$el.before userView.render().el
            @remove()
            App.execute 'message',
              type: 'success'
              text: 'user "<i>'+model.get('id')+'</i>" updated'
          else
            loginCredentials = {username: model.get('username'),password: model.get('password')}
            $.post('/user/login', JSON.stringify(loginCredentials), (data)->
              loginView = new LoginView
              loginView.loginUser(data)

              App.execute 'message',
                type: 'success'
                text: 'user created'

              App.navigate '', true
            )

    cancelEdit: (e)->
      e.preventDefault()

      if @options.front_view
        if @model.has 'id'
          prevView = new @options.front_view {model: @model}
          @$el.before(prevView.render().el)
      else
        App.navigate '', true
      @remove()

  UserFormView
