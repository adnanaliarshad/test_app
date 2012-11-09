#def dart_ad(ad_position, ad_rand)
@get_dart_ad = (ad_position, ad_rand) ->
  loc = document.location.href

  if loc.indexOf("/gallery") > -1
    ad_name = "gallery"
  else if loc.indexOf("/slide") > -1
    ad_name = "single"
  else if loc.indexOf("/new") > -1
    ad_name = "entry"
  else
    ad_name = "entry"

  ad_append = ""
  ad_dcopt = ""

  if ad_position == "top"
    ad_pos = 1
    ad_size = "728x90,970x66"
    ad_dcopt = "dcopt=ist;"

  else if ad_position == "bottom"
    ad_append = ".b"
    ad_pos = 4
    ad_size = "728x90,468x60"

  else if ad_position == "side"
    ad_pos = 2
    ad_size = "300x250,2x2"


  script_tag ="<script language=\"javascript\" type=\"text/javascript\" src=\"//ad.doubleclick.net/adj/nbcu.ivillage#{ad_append}/votigo_famvaca_ugcphoto_tile-#{ad_pos};chan=ivillage;sect=votigo;sub=famvaca;cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;#{ad_dcopt}pos=#{ad_pos};tile=#{ad_pos};sz=#{ad_size};ord=#{ad_rand}?;\"></script>"
  no_script_tag = "<noscript> <a href=\"//ad.doubleclick.net/jump/nbcu.ivillage#{ad_append}/votigo_famvaca_ugcphoto_tile-#{ad_pos};chan=ivillage;sect=votigo;sub=famvaca;cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;pos=#{ad_pos};tile=2;sz=#{ad_size};ord=#{ad_rand}?\"><img src=\"http://ad.doubleclick.net/ad/nbcu.ivillage#{ad_append}/votigo_famvaca_ugcphoto_tile-#{ad_pos};chan=ivillage;sect=votigo;sub=famvaca;cont=ugcphoto;pageid=#{ad_name};!c=ugc;!c=tool;!c=nopopup;pos=#{ad_pos};tile=#{ad_pos};sz=#{ad_size};ord=#{ad_rand}?\" border=\"0\" alt=\"Click Here!\" /></a> </noscript>"
  script_tag + no_script_tag
#end

@iv_refresh_dart_ads = ->
  rand = Math.round(Math.random()*1000000000000)
  $top_ad = $('#ad-top-banner')
  if $top_ad.length and ad_count[0]
    ad_count[0] = false
    $top_ad.html writeCapture.sanitize(get_dart_ad("top", rand),
      done: ->
        ad_count[0] = true
    )
  $bot_ad = $('#ad-bottom-banner')
  if $bot_ad.length and ad_count[1]
    ad_count[1] = false
    $bot_ad.html writeCapture.sanitize(get_dart_ad("bottom", rand),
      done: ->
        ad_count[1] = true
    )
  $side_ad = $('#ad-side-banner')
  if $side_ad.length and ad_count[2]
    ad_count[2] = false
    $side_ad.html writeCapture.sanitize(get_dart_ad("side", rand),
      done: ->
        ad_count[2] = true
    )
  return

unless ad_count?
  @ad_count = []
  ad_count[0] = ad_count[1] = ad_count[2] = true