window.Votigo = window.Votigo or {}
(->
  window.Votigo.tracking = (linkVar, eVar) ->
    if s_iv?
      s_iv.linkTrackVars = linkVar
      s_iv.eVar13 = eVar
      s_iv.tl(this, 'o', eVar)
)()



