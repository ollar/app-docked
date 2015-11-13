define ['mandrill'], (mandrill)->
  mandrill_client = new mandrill.Mandrill('Z7q2kKIOhDIr0vzJGJCCgQ')
  message = (html, toemail, toname, subject='Canteen Info', text=null, success=null, fail=null)->
    async = no
    ip_pool = "Main Pool"

    format_message =
      "html": html
      "text": text
      "subject": subject
      "from_email": "message.from_email@example.com"
      "from_name": "Canteen App"
      "to": [
        "email": toemail
        "name": toname
        "type": "to"
      ]

      "headers":
        "Reply-To": "message.reply@example.com"
      "important": false
      "track_opens": null
      "track_clicks": null
      "auto_text": null
      "auto_html": null
      "inline_css": null
      "url_strip_qs": null
      "preserve_recipients": null
      "view_content_link": null
      "bcc_address": "message.bcc_address@example.com"
      "tracking_domain": null
      "signing_domain": null
      "return_path_domain": null
      "merge": true
      "merge_language": "mailchimp"

    mandrill_client.messages.send
      "message": format_message
      "async": async
      "ip_pool": ip_pool
    , (result)->
      console.log(result)
      success() if success?
    , (e)->
      # Mandrill returns the error as an object with name and message keys
      console.log('A mandrill error occurred: ' + e.name + ' - ' + e.message)
      fail() if fail?

  message
