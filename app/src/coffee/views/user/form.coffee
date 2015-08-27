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

    model: new UserModel()

    initialize: (options)->
      @options = options || {}
      if @options.user_id
        @model.set({'id':@options.user_id})
        @model.fetch
          success: =>
            @render()
          error: (collection, response, options)=>
            App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
      @uid = @model.get('id')

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
            App.ventFunctions.updateLocalUser()


          # Creating user from user list page
          if !@uid and @options.front_view
            @options.front_view.model = model
            @options.front_view.render().$el.show()
            @remove()
            App.execute 'message',
              type: 'success'
              text: translate 'user created'

          # Updating user from user list page
          if @uid and @options.front_view
            @options.front_view.model = model
            @options.front_view.render().$el.show()
            @remove()
            App.execute 'message',
              type: 'success'
              text: translate 'user updated', model.get('username')

          # Updating profile
          if @uid and !@options.front_view
            App.execute 'message',
              type: 'success'
              text: translate 'your profile updated'

            App.navigate ''

          # Register new user
          if !@uid
            loginCredentials = {username: model.get('username'),password: model.get('password')}
            $.post '/user/login', JSON.stringify(loginCredentials), (data)->
              loginView = new LoginView
              loginView.loginUser(data)

              App.execute 'message',
                type: 'success'
                text: translate 'welcome aboard'

              App.navigate ''

    cancelEdit: (e)->
      e.preventDefault()

      if !@options.front_view
        return App.navigate ''

      if @options.front_view and @model.has 'id'
        @options.front_view.$el.show()
      else
        @options.front_view.$el.remove()

      @remove()

  UserFormView
