define [
  'app'
  'marionette'
  'translate'
  'env'
  'marked'
], (App, Mn, translate, ENV, marked)->
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

    # ====================================

    # Backbone Tweaks ==============================================================================

    BackboneSync = Backbone.sync
    Backbone.sync = (method, model, options)->
      if $.cookie('access_token')
        options.headers = {'Authorization': $.cookie('access_token')}

      # App.vent.trigger 'loading:start'
      BackboneSync.apply(@, arguments)
      # App.vent.trigger 'loading:done'


    # Underscore tweaks ============================================================================

    _.mixin
      t: translate


    # AJAX Tweaks ==================================================================================

    $.ajaxPrefilter ( options, originalOptions, jqXHR ) ->
      options.url = 'http://' + ENV.prod_ip + ':5000' + options.url
      options.dataType = "jsonp"
      options.crossDomain = yes
      options.contentType = "application/json; charset=utf-8"

  do Prefix
