module JavascriptHelpers

  def user_sigin_status
    javascript_tag(
        "$(document).ready(function(){
          $('#iv_home_login_openOLD').removeClass('sso-sign-in');
          $('.sso-register').removeClass('sso-register');
           if ( $.cookie('iv_id') != null && $.cookie('iv_auth') != null && $.cookie('iv_log_dt') != null ) {
              $('.userbox').empty();
              var user = ( $.cookie('iv_id') != null && $.cookie('iv_id')!='[object Object]' ) ?
              '<a href='http://www.ivillage.com/profile/private'>'+$.cookie('iv_id')+'</a> | ' : '';
              str  =   '<strong>Welcome! ';    str  +=  user;    str  +=
              '<a href='http://www.ivillage.com/profile/private'>Edit Profile</a> | ';
              str  +=  '<a href='http://www.ivillage.com/user/logout?forward=http://'+window.location.host+'/'
              style='cursor:default;'>Log Out</a>';
              str  +=  '</strong>';        $('.userbox').html(str);  }
              });"
    )
  end

  def dart_ad_rand
    javascript_tag("
    var randDARTNumber=0;
    function genSetRandDARTNumber() {
      randDARTNumber = Math.round(Math.random()*1000000000000); }
      genSetRandDARTNumber();
      if (typeof eTandomAd == 'undefined') {
        eTandomAd = 'none';
      }
    ")
  end

  def dart_ad(ad_position, ad_rand)
    if action_name == "gallery"
      ad_name = "gallery"
    elsif action_name == "slide"
      ad_name = "single"
    elsif action_name == "new"
      ad_name = "entry"
    else
      ad_name = "entry"
    end

    ad_append = ""
    ad_dcopt = ""

    if ad_position == "top"
      ad_pos = 1
      ad_size = "728x90,970x66"
      ad_dcopt = "dcopt=ist;"

    elsif ad_position == "bottom"
      ad_append = ".b"
      ad_pos = 4
      ad_size = "728x90,468x60"

    elsif ad_position == "side"
      ad_pos = 2
      ad_size = "300x250,2x2"
    end

    sub = @contest['dart_ads']['sub']
    tile = @contest['dart_ads']['tile']
    script_tag ="<script language=\"javascript\" type=\"text/javascript\" src=\"//ad.doubleclick.net/adj/nbcu.ivillage#{ad_append}/#{tile}-#{ad_pos};chan=ivillage;sect=votigo;sub=#{sub};cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;#{ad_dcopt}pos=#{ad_pos};tile=#{ad_pos};sz=#{ad_size};ord=#{ad_rand}?;\"></script>".html_safe
    no_script_tag = "<noscript> <a href=\"//ad.doubleclick.net/jump/nbcu.ivillage#{ad_append}/#{tile}-#{ad_pos};chan=ivillage;sect=votigo;sub=#{sub};cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;pos=#{ad_pos};tile=2;sz=#{ad_size};ord=#{ad_rand}?\"><img src=\"http://ad.doubleclick.net/ad/nbcu.ivillage#{ad_append}/#{tile}-#{ad_pos};chan=ivillage;sect=votigo;sub=#{sub};cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;pos=#{ad_pos};tile=#{ad_pos};sz=#{ad_size};ord=#{ad_rand}?\" border=\"0\" alt=\"Click Here!\" /></a> </noscript>".html_safe
    script_tag + no_script_tag
  end

  def mobify_tag
    mobify = javascript_tag("(
    function(a){
      function b(a,b){
        if(+a)
          return~a||(d.cookie=h+\"=; path=/\");
          j=d.createElement(e),k=d.getElementsByTagName(e)[0],j.src=a,b&&(j.onload=j.onerror=b),k.parentNode.insertBefore(j,k)
      }
      function c(){
        n.api||b(l.shift()||-1,c)
      }
      if(this.Mobify)
        return;
      var d=document,e='script',f='mobify',g='.'+f+'.com/',h=f+'-path',i=g+'un'+f+'.js',j,k,l=[!1,1],m;
      var n=this.Mobify={points:[+(new Date)],tagVersion:[6,1]},o=/((; )|#|&|^)mobify-path=([^&;]*)/g.exec(location.hash+'; '+d.cookie);o?(m=o[3])&&!+(m=o[2]&&sessionStorage[h]||m)&&(l=[!0,'//preview'+g+escape(m)]):(l=a()||l,l[0]&&l.push('//cdn'+i,'//files01'+i)),l.shift()?(d.write('<plaintext style=\"display:none;\">'),setTimeout(c)):b(l[0])})(function()
      {if(/ip(hone|od|ad)|android|blackberry.*applewebkit/i.test(navigator.userAgent))
        {
          return[1,'//cdn.mobify.com/sites/ivillage-mobile-tablet/production/mobify.js']
        }
      }
      )")
    mobify_redirect = javascript_include_tag "//m.ivillage.com/mobify/redirect.js"
    mobify_js = javascript_tag ("try { _mobify('//m.ivillage.com/'); }  catch(err) {}")
    mobify + mobify_redirect + mobify_js

  end

  def omniture_tracking
    javascript_tag( <<-JS )
      var iv_titletag = "#{@contest['omniture']['titletag']}";
      var iv_section = "#{@contest['omniture']['section']}";
      var iv_subsection1 = "#{@iv_subsection1}";
      var iv_pageid = "iVillage - Votigo";
      var iv_contenttype = "Contest";
      var iv_stitle = "#{@contest['omniture']['titletag']}";
      var iv_searchType = "";
      var iv_dartZone = "#{@contest['omniture']['dartZone']}_#{@iv_subsection1}";
      var iv_pubDate = "";
      var iv_product = "";
      var iv_events = "";
      var iv_partner = "";
      var iv_server_timestamp = #{Time.now.to_i};
    JS
  end

  def script_runner
    "<script class=\"script-runner\" id=\"Runner-Script\" type=\"text/javascript\">
        var page_item = {\"url\":\"#{request.path}\",\"id\":#{params[:id].nil? ? 'null' : params[:id]}};
        console.log(iVillage);
        var iVillage = iVillage || {};
        iVillage.settings = {}
        iVillage.siteName = \"iVillage\";
        iVillage.sitePrefix = \"\";
        iVillage.vertical_id = 8;
        iVillage.ev13_prefix = \"iv:ivillage\";
        iVillage.controller = \"#{params[:controller].capitalize}_Controller\";
        iVillage.action = \"#{params[:action]}\";
        iVillage.services = \"http://api.ivillage.com/services/\";
        iVillage.gigya_api_key = \"2_TAACrzG-_a9IkzLfWB3YsVoaBvKoZSfmy-eAfFSA0_XZPEk1Lpd5dWthUDHdRtu-\";
        iVillage.settings.chartbeat = {}
        iVillage.settings.chartbeat.domain = \"ivillage.com\"
        iVillage.loyalty_public_key      = \"9cc386baa5ae27061226323c67b25ffa\";
        iVillage.loyalty_iv_domain       = \"ivillage.com\";
        iVillage.loyalty_vendor_domain   = \"api.v2.badgeville.com\";
        iVillage.loyalty_denied_vertical = [4,6,9];

        /* Charbeat header integration */
        var _sf_startpt = (new Date()).getTime();

        /* Execute Runner */
        var jsRunStart = new Date();
        console.log(\"jsRunStart\", jsRunStart);
        jQuery(iVillage.activate_runners);
        <!-- NOT_IN_WRAPPER_START - Wrapper Hook - DON'T DELETE -->
        jQuery(document).ready(function() {
          setTimeout(\"jQuery(iVillage.activate_click)\", 1000);
          var jsRunEnd = new Date();
          console.log(\"jsRunDiff 1\", (jsRunEnd-jsRunStart) );
        });
        <!-- NOT_IN_WRAPPER_END - Wrapper Hook - DON'T DELETE -->
    </script>".html_safe
  end

  def google_conversion_tracking_pixel
    if flash[:notice] != AppConfig["user_messages"]["successful"]
      ord = rand(10000000000000000000)
      "<!-- Google Code for Endless Summer UCG Conversion Page -->
          <script type='text/javascript'>
          /* <![CDATA[ */
          var google_conversion_id = 966220740;
          var google_conversion_language = 'en';
          var google_conversion_format = '3';
          var google_conversion_color = 'ffffff';
          var google_conversion_label = 'EwI9CIT_nwMQxLfdzAM';
          var google_conversion_value = 0;
          /* ]]> */
          </script>
          <script type='text/javascript' src='http://www.googleadservices.com/pagead/conversion.js'>
          </script>
          <noscript>
          <div style='display:inline'>
          <img height='1' width='1' style='border-style:none;' alt='' src='https://www.googleadservices.com/pagead/conversion/966220740/?value=0&label=EwI9CIT_nwMQxLfdzAM&guid=ON&script=0&random=" + ord.to_s + "'/>
          </div>
      </noscript>".html_safe
    end
  end

  def get_host
    "<script>if(window.location.host.indexOf('contest-www.playard.astrology.com') > -1 ||
      window.location.host.indexOf('local.ivillage.com') > -1 ){
       host = '//' + window.location.host
    } else {
       host = '//www.ivillage.com'
       if (window.location.pathname.indexOf('stag') > -1){
         host = host + '/staging'
       }
    }</script>".html_safe
  end
  
end