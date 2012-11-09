(($) ->
  init_gigya_vertical = (self) ->
    interval = setInterval(->
      if typeof gigya isnt "undefined"
        clearInterval interval
        load_gigya_vertical self
    , 1000)
  load_gigya_vertical = (self) ->
    ua = new gigya.socialize.UserAction()
    ua.setLinkBack document.location.href
    ua.setTitle $('.b-info_entryname').text()
    ua.setDescription "Share a photo of your greatest Halloween costume for the chance to win $2,000!"
    image =
      type: "image"
      src: $('.jcarousel-item img').attr('src')
      href: document.location.href
    ua.addMediaItem(image);

    params =
      userAction: ua
      shareButtons: "share,facebook,twitter,pinterest"
      containerID: self.attr('id')
      showCounts: 'top'
      layout: 'vertical'

    gigya.socialize.showShareBarUI params

  $.fn.b_gigya_vertical = ->
    @each ->
      self = $(this)
      init_gigya_vertical self
) jQuery