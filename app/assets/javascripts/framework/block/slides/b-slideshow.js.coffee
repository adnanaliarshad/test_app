(($) ->
  `function carousel_itemLoadCallback(carousel, state)
  {
      if (window.location.pathname.indexOf("stag") > -1)
        contest_name = window.location.pathname.split('/')[3]
      else
        contest_name = window.location.pathname.split('/')[2]
      if (state != 'init') {
          if (state == 'prev')
              return;
          if (carousel.has(carousel.first))
              return;
          if (page_no > total_pages)
              return;
      }

      carousel.lock();
      $('.b-info, div[class*="b-slides_social"]').fadeOut();
      if (window.location.href.indexOf('facebook') == -1 ) {
        if(window.location.pathname.indexOf("/photo-contests") > -1)
          url = '/photo-contests/' + contest_name + '/next_slides?page_no='+ page_no++ +'&sort=created&direction=desc&limit='+limit
        else
          url = '/next_slides?page_no='+ page_no++ +'&sort=created&direction=desc&limit='+limit
      } else {
        if(window.location.host.indexOf("contest-www.playard.astrology.com") > -1 || window.location.host.indexOf("local.ivillage.com") > -1)
           host = window.location.host;
        else
           host = "www.ivillage.com";
           if (window.location.pathname.indexOf("stag") > -1)
             host = host + "/staging"
        if(window.location.pathname.indexOf("/photo-contests") > -1)
          url = '//' + host + '/photo-contests/' + contest_name + '/next_slides?page_no='+ page_no++ +'&sort=created&direction=desc&limit='+limit
        else
          url = '//' + host + '/next_slides?page_no='+ page_no++ +'&sort=created&direction=desc&limit='+limit
      }
      $.getJSON(url, function(data) {
          total_pages = Math.ceil(parseFloat(data["total_count"])/limit);
          var count = carousel.first;
          if(data['error'] == "Signature Error") {
            alert('Something has went wrong. Please try again later.')
          }
          $.each(data["Entries"], function(key, value){
              var desc = [];
              desc["already_voted"] = value["Entry"]["already_voted"];
              var vote_up = parseFloat(value["Entry"]["vote_count"]);
              var vote_down = parseFloat(value["Entry"]["leave_it_count"]);
              desc["vote_up"] = parseInt((vote_up/(vote_up+vote_down))*100);
              desc["vote_down"] = parseInt((vote_down/(vote_up+vote_down))*100);
              desc["entry_id"] = value["Entry"]["entry_id"];
              desc["entryname"] = value["Entry"]["entryname"];
              desc["description"] = value["Entry"]["Photo"]["description"];
              desc["thumb_pic"] = value["Entry"]["Photo"]["thumb_pic"];
              desc["profile_pic"] = value["Entry"]["User"]["profile_pic"];
              desc["social_id"] = value["Entry"]["User"]["social_id"];
              desc["username"] = value["Entry"]["username"];
              if(desc["username"] == "username" || desc["username"] == "NA") {
                desc["username"] = value["Entry"]["User"]["username"];
              }
              description[count] = desc;
              med_img = value["Entry"]["Photo"]["medium_pic"];
              if(window.location.href.indexOf("facebook") > -1){
                med_img = med_img.replace("http://","https://s3.amazonaws.com/")
              }
              carousel.add(count++ , carousel_getItemHTML(med_img, value["Entry"]["Photo"]["description"]));


              add_socail_column(desc["entry_id"], desc["entryname"], desc["description"], desc["thumb_pic"], desc["already_voted"], desc["vote_up"], desc["vote_down"])

          });
          $('#b-gigya').b_gigya();
          if(page_no > total_pages) {
              carousel.size(count - 1);
          } else carousel.size(count);
          add_description(carousel.first);
          //$('.b-slides_rate_loader').addClass('gigya_loader_show');
          carousel.unlock();
          $('.b-gigya-vertical').fadeIn();
          //$('.b-slides_rate_loader').removeClass('gigya_loader_show');
      });
  };`

  init_refresh_ads = (self) ->
    self.find("." + classes.next_btn + ", ." + classes.prev_btn).live "click", ->
      iv_refresh_dart_ads()
      $('#b-gigya').b_gigya();
      if s_iv?
        s_iv.linkTrackVars = "prop25"
        s_iv.prop25 = "iVillage:" + Votigo.contest_name + ":" + $('.b-info_entryname').text().trim()
        s_iv.t($(this),'o',s_iv.prop25)
        if !paegName?
          window.paegName = s_iv.pageName
        s_iv.pageName = paegName + $('.b-info_entryname').text().trim()
      false

  init_binding = (self) ->
    $(".b-view_content").delegate "." + classes.social_rate + " a", "click", ->
      url = $(this).attr("href")
      parent = $(this).parent()
      parent.hide()
      #$('.vote').hide()
      $('.b-slides_rate_loader').show()
      iv_refresh_dart_ads()
      $.ajax
        method: "GET"
        url: url
        success: (response) ->
          $('.b-slides_rate_loader').hide()
          parent.show()
          if response['error'] is "Signature Error"
            alert('Something has went wrong. Please try again later.')
          else
            if response['vote'] != 0
              parent.html "<span class='rate_up'>" + response["love_it"] + "%</span><span class='rate_down'>" + response["leave_it"] + "%</span>"
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
              if response["vote"] is 0 && response["error"] is "User already voted."
                $(".b-slides_social-" + $("span.b-info_entry_id").text()).find('.' + classes.rate).show()
                $(".b-slides_social-" + $("span.b-info_entry_id").text()).find("." + classes.social_rate).hide()
                alert("You already voted.")
              else
                if response["error"] is "Signature Error"
                  alert("Something went wrong. Please try again later.")
                else
                  alert("User needs to signin to vote.")
                parent.show()
      false

  carousel_getItemHTML = (url, alt) ->
    "<div class=\"img-wrapper\"><img src=\"" + url + "\" alt=\"" + alt + "\" /></div>"

  add_description = (position) ->
    $("span.b-info_entry_id").text description[position]["entry_id"]
    $("h3.b-info_entryname").text description[position]["entryname"]
    $("p.b-info_description").text description[position]["description"]
    avatar_image = "<div style ='padding:5px; width:60px;'> <img src='http://www.ivillage.com/photo/get-avatar?person_id="+ description[position]['social_id']+"&width=50&height=50'></div>"
    if [position]['username'] != "NA"
      $(".b-info_user-info p").html("Uploaded By: " +  description[position]['username'] + avatar_image)
    else
      $(".b-info_user-info p").text("")
    $('.b-slides_social-' + description[position]["entry_id"]).show().siblings("div[class*='b-slides_social']").hide()
    if s_iv?
      if !paegName?
        window.paegName = s_iv.pageName
      s_iv.pageName = paegName + $('.b-info_entryname').text().trim()

  add_socail_column = (e_id, e_name, desc, t_pic, a_voted, v_up, v_down) ->
    if (window.location.pathname.indexOf("stag") > -1)
      contest_name = window.location.pathname.split('/')[3]
    else
      contest_name = window.location.pathname.split('/')[2]
    $social = $("<div class='b-slides_social-" + e_id + "' />").html("<div class='b-slides_text'>#{$('#b-slides_question').text()}</div><div class='b-slides_rating' />")
    if a_voted and $.trim($('.user_id').text()) != "false"
      $social.find('.b-slides_rating').html("<span class='rate_up'>#{v_up}%</span><span class='rate_down'>#{v_down}%</span>")
    else
      host = ""
      if (window.location.href.indexOf('facebook') > -1 )
        if window.location.host.indexOf("contest-www.playard.astrology.com") > -1 || window.location.host.indexOf("local.ivillage.com") > -1
           host = "//#{window.location.host}"
        else
          host = "//www.ivillage.com"
          if (window.location.pathname.indexOf("stag") > -1)
             host = host + "/staging"
        if(window.location.pathname.indexOf("/photo-contests") > -1)
          vote_up = "#{host}/photo-contests/#{contest_name}/vote?entry_id=#{e_id}&vote_type=love_it"
          vote_down = "#{host}/photo-contests/#{contest_name}/vote?entry_id=#{e_id}&vote_type=leave_it"
          g_source = "//contest-www.astrology.com/assets/slides/thumbs-up.png"
          r_source = "//contest-www.astrology.com/assets/slides/thumbs-down.png"
          l_source = "//contest-www.astrology.com/assets/slides/loading.gif"
          entry_share_source = "//contest-www.astrology.com/assets/slides/share-entry.png"
        else
          vote_up = "#{host}/vote?entry_id=#{e_id}&vote_type=love_it"
          vote_down = "#{host}/vote?entry_id=#{e_id}&vote_type=leave_it"
          g_source = "/assets/slides/thumbs-up.png"
          r_source = "/assets/slides/thumbs-down.png"
          l_source = "/assets/slides/loading.gif"
          entry_share_source = "/assets/slides/share-entry.png"
      else
        if(window.location.pathname.indexOf("/photo-contests") > -1)
          vote_up = "#{host}/photo-contests/#{contest_name}/vote?entry_id=#{e_id}&vote_type=love_it"
          vote_down = "#{host}/photo-contests/#{contest_name}/vote?entry_id=#{e_id}&vote_type=leave_it"
          g_source = "//contest-www.astrology.com/assets/slides/thumbs-up.png"
          r_source = "//contest-www.astrology.com/assets/slides/thumbs-down.png"
          l_source = "//contest-www.astrology.com/assets/slides/loading.gif"
          entry_share_source = "//contest-www.astrology.com/assets/slides/share-entry.png"
        else
          vote_up = "#{host}/vote?entry_id=#{e_id}&vote_type=love_it"
          vote_down = "#{host}/vote?entry_id=#{e_id}&vote_type=leave_it"
          g_source = "/assets/slides/thumbs-up.png"
          r_source = "/assets/slides/thumbs-down.png"
          l_source = "/assets/slides/loading.gif"
          entry_share_source = "/assets/slides/share-entry.png"

      $social.find('.b-slides_rating').html('<a href=' + vote_up + '><img alt="Green_thumb" class="rate_image" src=' + g_source + '></a><a  href=' + vote_down + '><img alt="Red_thumb" class="rate_image" src=' + r_source + '></a>')

    $social.append("<div class='vote' style='display: none'><span class='rate_up'>#{v_up}%</span><span class='rate_down'>#{v_down}%</span></div>")

    if ($('.b-facebook').length)
      $social.append("<div class='b-slides_rate_loader'><img alt='Loading...' src='#{l_source}'></div><div id='b-slides_share'><a image_name='#{e_name}' image_id='#{e_id}' image_desc='#{desc}' image='#{t_pic}' class='b-slides_entry_social_share_fb' href='#'><img src='#{entry_share_source}' alt='Share-entry'></a></div>")
    else
      $social.append("<div class='b-slides_rate_loader'><img alt='Loading...' src='#{l_source}'></div><div id='b-gigya-vertical-" + e_id + "' class='b-gigya-vertical' ></div>")
    $social.appendTo ".b-view_content .group"

    $('.b-info, div[class*="b-slides_social-' + desc["entry_id"] + '"]').fadeIn()

    if ($('.b-facebook').length == 0)
      if (window.location.pathname.indexOf("stag") > -1)
        url = "http://www.ivillage.com/staging/photo-contests/#{$('#contest_name').text()}/slides/#{e_id}"
      else
        url = "http://www.ivillage.com/photo-contests/#{$('#contest_name').text()}/slides/#{e_id}"
      $.fn.b_gigya_vertical_change_ua "b-gigya-vertical-" + e_id, e_name, desc, url, t_pic, url

  carousel_onBeforeAnimation = (carousel, element, position, state) ->
    add_description position  unless typeof description[position] is "undefined"

  init_slideshow = (self) ->
    self.find("#" + classes.slideshow).jcarousel
      itemLoadCallback: carousel_itemLoadCallback
      itemFirstInCallback:
        onBeforeAnimation: carousel_onBeforeAnimation
      scroll: 1

  init_fb_share = (self) ->
    $('.b-facebook .' + classes.facebook_button).live "click", ->
      $this = $(this)
      obj =
        id: $this.attr('image_id')
        thumb_pic: $this.attr('image')
        title: $this.attr('image_name')
        caption: ""
        description: $this.attr('image_desc')
      postToFeed(obj)
      return false

  total_pages = 0
  page_no = 1
  limit = 4
  description = []

  classes =
    slideshow: "carousel"
    social_rate: 'b-slides_rating'
    next_btn: 'jcarousel-next'
    prev_btn: 'jcarousel-prev'
    facebook_button: "b-slides_entry_social_share_fb"
    rate: "vote"

  $.fn.b_slideshow = ->
    @each ->
      self = $(this)
      init_binding self
      init_slideshow self
      init_fb_share self
      init_refresh_ads self
) jQuery

