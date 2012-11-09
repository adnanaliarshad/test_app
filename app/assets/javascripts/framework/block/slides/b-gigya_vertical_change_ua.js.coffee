(($) ->
#  init_loader = (res) ->
#    $('.b-slides_rate_loader').hide()
#    alert "loaded"

  init_gigya_vertical = (c_id, title, desc, linkback, src, href) ->
    interval = setInterval(->
      if typeof gigya isnt "undefined"
        clearInterval interval
        load_gigya_vertical c_id, title, desc, linkback, src, href
    , 1000)

  load_gigya_vertical = (c_id, title, desc, linkback, src, href) ->
#    $('.b-slides_rate_loader').show()
#    $(c_id).hide()
    ua = new gigya.socialize.UserAction()
    ua.setUserMessage "Vote for my entry in the Contest on iVillage!"
    ua.setDescription "Share a photo of your greatest Halloween costume for the chance to win $2,000!"
    ua.setTitle title
    ua.setLinkBack linkback
    image =
      type: "image"
      src: src
      href: href
    ua.addMediaItem(image);
    params =
      userAction: ua
      shareButtons: "Share"
      containerID: c_id
#      showCounts: "top"
#      layout: "vertical"
#      callback: init_loader

    gigya.socialize.showShareBarUI params

  $.fn.b_gigya_vertical_change_ua = (c_id, title, desc, linkback, src, href) ->
    init_gigya_vertical c_id, title, desc, linkback, src, href

) jQuery