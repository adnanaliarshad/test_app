(($) ->
  init_gigya = (self) ->
    interval = setInterval(->
      if typeof gigya isnt "undefined"
        clearInterval interval
        load_gigya self
    , 1000)
  load_gigya = (self) ->
    ua = new gigya.socialize.UserAction()
    ua.setLinkBack document.location.href
    ua.setDescription "Share a photo of your greatest Halloween costume for the chance to win $2,000!"
    ua.setTitle "iVillage Halloween Costumes Contest"
    params =
      userAction: ua
      shareButtons: "Facebook,Twitter,Pinterest,google-plusone,Email"
      containerID: self.attr('id')
    gigya.socialize.showShareBarUI params

  $.fn.b_gigya = ->
    @each ->
      self = $(this)
      init_gigya self
) jQuery