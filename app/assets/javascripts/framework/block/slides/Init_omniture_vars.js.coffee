$ ->
  if s_iv?
    if !paegName?
      window.paegName = s_iv.pageName
    s_iv.pageName = paegName + $('.b-slide .b-info_entryname').text().trim()