define [
  'app'
  'marionette'
  'translate'
  'marked'
], (App, Mn, translate, marked)->
  Prefix = ()->

    # ====================================
    # Setting help functions and options
    # ====================================

    $.fn.serializeObject = ->
      o = {}
      a = @serializeArray()
      $.each a, ->
        if o[@name] != undefined
          if !o[@name].push
            o[@name] = [ o[@name] ]
          o[@name].push @value or ''
        else
          o[@name] = @value or ''
        return
      o

    marked.setOptions
      renderer: new marked.Renderer()
      gfm: true
      tables: true
      breaks: false
      pedantic: false
      sanitize: true
      smartLists: true
      smartypants: false

    # Marionette Tweaks ============================================================================

    Marionette.Region.prototype.attachHtml = (view)->
      @$el.fadeOut()
      @$el.html(view.el)
      @$el.fadeIn()
      return

    # Backbone Tweaks ==============================================================================

    BackboneSync = Backbone.sync
    Backbone.sync = (method, model, options)->
      if $.cookie('access_token')
        options.headers = {'Authorization': $.cookie('access_token')}

      BackboneSync.apply(@, arguments)

    # Underscore tweaks ============================================================================

    _.mixin
      t: translate


  do Prefix
