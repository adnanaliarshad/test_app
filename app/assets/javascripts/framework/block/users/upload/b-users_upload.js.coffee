(($) ->
  init_tracking = (self) ->
    self.find("." + classes.login).live "click", ->
      if s_iv?
        s_iv.linkTrackVars = "prop25"
        s_iv.prop25 = "iVillage:" + Votigo.contest_name + ":Click here to log-in"
        s_iv.tl this, 'o', s_iv.prop25
    self.find("." + classes.register).live "submit", ->
      if s_iv?
        s_iv.linkTrackVars = "eVar13"
        s_iv.eVar13 = Votigo.contest_name + "|Register & Submit Photo"
        s_iv.tl $(this), 'o', s_iv.eVar13


  classes =
    login: "b-profile_log-in"
    register: "b-users_upload_form"


  $.fn.b_users_upload = ->
    @each ->
      self = $(this)
      init_tracking self

) jQuery