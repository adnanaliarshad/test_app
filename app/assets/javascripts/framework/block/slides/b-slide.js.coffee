(($) ->
  init_slider = (self) ->
    self.find("." + classes.prev + ", ." + classes.next).live "click", ->
      url = $(this).attr("url")
      if window.location.href.indexOf("?facebook=true") > -1 || window.location.href.indexOf("code") > -1
        url = "#{url}&facebook=true"
      $(".jcarousel-item").addClass "jcarousel-item-placeholder"
      $(".jcarousel-item img").hide()
      $(".b-slides_social, .b-info").fadeOut()
      $(".jcarousel-next").addClass "jcarousel-next-disabled"
      $(".jcarousel-prev").addClass "jcarousel-prev-disabled"
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          if response['error'] is "Signature Error"
            $(".jcarousel-item").removeClass "jcarousel-item-placeholder"
            $(".jcarousel-next").addClass "jcarousel-next-disabled"
            $(".jcarousel-prev").addClass "jcarousel-prev-disabled"
            $(".b-slides_social, .b-info").fadeIn()
            $(".jcarousel-item img").show()
            alert("Something went wronmg please  try again later.")
          else
            $("." + classes.content).html response
            $('#b-gigya').b_gigya()
            if s_iv?
              s_iv.linkTrackVars = "prop25"
              s_iv.prop25 = "iVillage:" + Votigo.contest_name + ":" + $('.b-info_entryname').text().trim()
              s_iv.t($(this),'o',s_iv.prop25)
              if !paegName?
                window.paegName = s_iv.pageName
              s_iv.pageName = paegName + $('.b-info_entryname').text().trim()

  init_vote = (self) ->
    self.find("." + classes.social_rate + " a").live "click", ->
      parent = undefined
      url = undefined
      url = $(this).attr("href")
      parent = $(this).parent()
      parent.hide()

      $('.b-slides_rate_loader').show()
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          $('.b-slides_rate_loader').hide()
          parent_show = 1
          if response["vote"] is 1
            parent.html "<span class='rate_up'>" + response["love_it"] + "%</span><span class='rate_down'>" + response["leave_it"] + "%</span>"
            parent.show()
            if s_iv?
              s_iv.linkTrackVars = "products,events"
              if url.indexOf("love_it") > -1
                s_iv.linkTrackEvents = "event39"
                s_iv.linkTrackVars += ",eVar39,event39"
              else
                s_iv.linkTrackEvents = "event46"
                s_iv.linkTrackVars += ",eVar46,event46"

              s_iv.products = ";" + Votigo.contest_name + ":" +  $('.b-info_entryname').text().trim()
              s_iv.tl $(this),'o',url
              parent.show()
          else
            if response["vote"] is 0 and response["error"] is "User already voted."
              $("." + classes.rate).show().parent().show()
              $("." + classes.social_rate + " a").hide()
              parent_show = 0
              alert("You already voted.")
            else
              if response["error"] is "Signature Error"
                alert("Something went wrong. Please try again later.")
              else
                alert("User needs to signin to vote.")
              parent.show()
      false

  init_back_to_gallery = (self) ->
    self.find("." + classes.back_to_gallery).live "click", ->
      if s_iv?
        s_iv.linkTrackVars = "eVar13"
        s_iv.eVar13 = Votigo.contest_name + "|Back to Gallery"
        s_iv.tl $(this),'o',Votigo.contest_name + "|Back to Gallery"

  init_fb_share = (self) ->
    $('.b-facebook #' + classes.facebook_button).live "click", ->
      $this = $(this)
      obj =
        id: $this.attr('image_id')
        thumb_pic: $this.attr('image')
        title: $this.attr('image_name')
        caption: ""
        description: $this.attr('image_desc')
      postToFeed(obj)
      return false

  classes =
    prev: "jcarousel-prev"
    next: "jcarousel-next"
    content: "b-view_content"
    user_name: "b-info_username"
    social_rate: "b-slides_rating"
    back_to_gallery: "b-slides_change-view"
    facebook_button: "b-slides_entry_social_share_fb"
    rate: "rate"

  $.fn.b_slide = ->
    @each ->
      self = $(this)
      init_slider self
      init_vote self
      init_back_to_gallery self
      init_fb_share self
) jQuery