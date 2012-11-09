(($) ->
  init_tracking = (self) ->
    self.find("." + classes.enter_now).live "click", ->
      tracking "eVar13", Votigo.contest_name + "|Enter Now"
    self.find("." + classes.vote_fav).live "click", ->
      tracking "eVar13", Votigo.contest_name + "|Vote For Your Fave"
    self.find("." + classes.vote).live "click", ->
      tracking "eVar13", Votigo.contest_name + "|Vote"


  tracking = (linkVar, eVar) ->
    if s_iv?
      s_iv.linkTrackVars = linkVar
      s_iv.eVar13 = eVar
      s_iv.tl this, 'o', eVar

  classes =
    enter_now: "b-welcome_enter-now"
    vote_fav: "b-welcome_vote-fav"
    vote: "b-welcome_vote"


  $.fn.b_welcome = ->
    @each ->
      self = $(this)
      init_tracking self

) jQuery