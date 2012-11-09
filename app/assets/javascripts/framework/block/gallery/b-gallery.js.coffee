(($) ->
  init_header_links = (self) ->
    self.find("." + classes.gallery_header + " ." + classes.links + " a, ." + classes.gallery_footer + " ." + classes.links + " a").live "click", ->
      url = $(this).attr("href")
      if window.location.href.indexOf("?facebook=true") > -1
        url = "#{url}&facebook=true"
      unless url is ""
        $('.overlay').show()
        iv_refresh_dart_ads()
        $.ajax
          method: "GET"
          url: url
          success: (response) ->
            $('.overlay').hide()
            $("." + classes.gallery).html response
            $('#b-gigya').b_gigya()
            if s_iv?
              s_iv.linkTrackVars = "prop25"
              s_iv.prop25 = "iVillage:" + Votigo.contest_name + ":gallery"
              s_iv.t $(this),'o',s_iv.prop25
      false
  init_order = (self) ->
    if (window.location.pathname.indexOf("stag") > -1)
      contest_name = window.location.pathname.split('/')[3]
    else
      contest_name = window.location.pathname.split('/')[2]
    self.find("." + classes.display_order).live "change", ->
      value = $(this).val()
      host = ""
      if window.location.href.indexOf("facebook") > -1
        if window.location.host.indexOf("contest-www.playard.astrology.com") > -1 || window.location.host.indexOf("local.ivillage.com") > -1
           host = "//#{window.location.host}"
        else
           host = "//www.ivillage.com"
           if (window.location.pathname.indexOf("stag") > -1)
             host = host + "/staging"
        if value != "new_created"
          if window.location.pathname.indexOf("/photo-contests") > -1
            url = "#{host}/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=" + value + "&direction=asc"
          else
            url = "#{host}/next_page?page_no=1&limit=6&sort=" + value + "&direction=asc"
        else
          if window.location.pathname.indexOf("/photo-contests") > -1
            url = "#{host}/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=new_created&direction=desc"
          else
            url = "#{host}/next_page?page_no=1&limit=6&sort=new_created&direction=desc"
      else
        if value != "new_created"
          if window.location.pathname.indexOf("/photo-contests") > -1
            url = "#{host}/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=" + value + "&direction=asc"
          else
            url = "#{host}/next_page?page_no=1&limit=6&sort=" + value + "&direction=asc"
        else
          if window.location.pathname.indexOf("/photo-contests") > -1
            url = "#{host}/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=new_created&direction=desc"
          else
            url = "#{host}/next_page?page_no=1&limit=6&sort=new_created&direction=desc"
      if window.location.href.indexOf("facebook") > -1
        url = "#{url}&facebook=true"
      $('.overlay').show()
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          $('.overlay').hide()
          $("." + classes.gallery).html response
    self.find("." + classes.categories + " select").live "change", ->
      value = $(this).val()
      if value!=""
        if window.location.pathname.indexOf("/photo-contests") > -1
          url = "/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=" + $('.' + classes.display_order).val() + "&direction=asc&category=" + value
        else
          url = "/next_page?page_no=1&limit=6&sort=" + $('.' + classes.display_order).val() + "&direction=asc&category=" + value
      else
        if window.location.pathname.indexOf("/photo-contests") > -1
          url = "/photo-contests/" + contest_name + "/next_page?page_no=1&limit=6&sort=" + $('.' + classes.display_order).val() + "&direction=asc"
        else
          url = "/next_page?page_no=1&limit=6&sort=" + $('.' + classes.display_order).val() + "&direction=asc"
      if window.location.href.indexOf("?facebook=true") > -1 || window.location.href.indexOf("code") > -1
        url = "#{url}&facebook=true"
      $('.overlay').show()
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          $('.overlay').hide()
          $("." + classes.gallery).html response
  init_vote = (self) ->
    if (window.location.pathname.indexOf("stag") > -1)
      contest_name = window.location.pathname.split('/')[3]
    else
      contest_name = window.location.pathname.split('/')[2]
    $("." + classes.social_rate + " a").live "click", ->
      $this = $(this)
      url = $this.attr("href")
      parent = $this.parent()
      parent.find('.b-gallery_rate_loader').show().siblings().hide()
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          $(".b-gallery_rate_loader").hide().siblings().not(" ." + classes.rate).show()
          if response["vote"] is 1
            parent.html "<span class='rate_up'>" + response["love_it"] + "%</span><span class='rate_down'>" + response["leave_it"] + "%</span>"
            if s_iv?
              s_iv.linkTrackVars = "products,events"
              if url.indexOf("love_it") > -1
                s_iv.linkTrackEvents = "event39"
                s_iv.linkTrackVars += ",eVar39,event39"
              else
                s_iv.linkTrackEvents = "event46"
                s_iv.linkTrackVars += ",eVar46,event46"
              s_iv.prop25 = "iVillage:" + Votigo.contest_name + ":gallery"
              s_iv.products= ";" + Votigo.contest_name + ":" + parent.siblings().first().text().trim()
              s_iv.tl $(this),'o',url
              parent.show()
          else
            if response["vote"] is 0 and response["error"] is "User already voted."
              element = parent.find("." + classes.rate)
              parent.html(element.html())
              $("." + classes.social_rate + " ." + classes.rate).hide()
              alert("You already voted.")
            else
              if response["error"] is "Signature Error"
                alert("Something went wrong. Please try again later.")
              else
                alert("User needs to signin to vote.")
              parent.show()
      false

  init_fb_share = (self) ->
    $('.b-facebook #' + classes.facebook_button).live "click", ->
      $this = $(this)
      obj =
        id: $this.attr('image_id')
        thumb_pic: $this.attr('image')
        title: $this.attr('image_name')
        caption: ""
        description: ""
      postToFeed(obj)
      return false

  classes =
    rate: "rate"
    gallery_header: "b-gallery_header"
    links: "links"
    gallery_footer: "b-gallery_footer"
    display_order: "b-gallery_display_order"
    categories: "display_categories"
    social_rate: "b-gallery_entry_social_rate"
    gallery: "b-gallery"
    thumb_up: "thumb_up"
    thumb_down: "thumb_down"
    facebook_button: "b-gallery_entry_social_share_fb"

  $.fn.b_gallery = ->
    @each ->
      self = $(this)
      $('<div class="overlay"/>').html('<div/>').hide().appendTo self

      init_header_links self
      init_order self
      init_vote self
      init_fb_share self

) jQuery