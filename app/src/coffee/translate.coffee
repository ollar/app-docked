define ['i18n!nls/locale'], (locale)->
  translate = (str)->
    if _.has locale, str
      locale[str]
    else
      '_'+str

  translate
