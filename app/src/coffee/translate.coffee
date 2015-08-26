define [
  'underscore'
  'i18n!nls/locale'
  ], (_, locale)->
  translate = (str, arg)->
    if _.has locale, str
      _.template(locale[str])({arg: arg})
    else
      '_'+str

  translate
