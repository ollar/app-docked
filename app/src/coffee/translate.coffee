define ['i18n!nls/locale'], (locale)->
  translate = (str)->
    locale[str]

  translate
