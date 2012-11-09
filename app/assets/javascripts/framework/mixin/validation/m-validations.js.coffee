(($) ->

  classes =
    self: "m-validations"
    element: "m-validations_element"
    type: "m-validations_type"
    name: "m-validations_name"
    border: "m-validations_border"
    border_wrong_place: "m-validations_border_wrong-place"
    invalid_border: "m-validations_invalid-border"
    accurate_place: "m-validations_accurate-place"
    accurate_place_field: "m-validations_accurate-place_field"
    birth_city_field: "m-validations_name_birth_city"
    error: "m-validations_error"
    spinner: "m-validations_spinner"

  show_error = (self, name, type) ->
    self.find("." + classes.border + "_" + name).addClass classes.invalid_border
    self.find("." + classes.error + "_" + name + "_" + type).show().siblings().hide()

  hide_error = (self, name, type) ->
    self.find("." + classes.error + "_" + name + "_" + type).hide()
    self.find("." + classes.border + "_" + name).removeClass classes.invalid_border  if self.find("." + classes.error + " li:visible").size() is 0

  handle_error = (self, valid_condition, name, type) ->
    if valid_condition
      hide_error self, name, type
      true
    else
      show_error self, name, type
      false


  local_validations =
    "file-type": (self, opts, element, name) ->
      input = element.find(":input")
      match = undefined
      if $.trim(input.val()) != ""
        if input.val().toLowerCase().lastIndexOf('.jpg') == -1 and input.val().toLowerCase().lastIndexOf('.jpeg') == -1 and input.val().toLowerCase().lastIndexOf('.gif') == -1
          match = false
        else
          match = true
      else
        match = true
      handle_error self, match, name, "file-type"

    "file-size": (self, opts, element, name) ->
      input = element.find(":input")
      match = undefined
      if $.trim(input.val()) != ""
        image_size = document.getElementById('image').files[0].size;
        if image_size > 3200000
          match = false
        else
          match = true
      else
        match = true
      handle_error self, match, name, "file-size"

    "18-above": (self, opts, element, name) ->
      year = element.find("#user_birth_date_year").val()
      month = element.find("#user_birth_date_month").val()
      day = element.find("#user_birth_date_day").val()
      dob = new Date(year,parseInt(month)-1,day)
      current_date = new Date()
      years_diff = (current_date- dob)/(1000*60*60*24*365)
      years_diff = parseInt(years_diff)
      match = undefined
      if years_diff < 18
        match = false
      else
        match = true
      handle_error self, match, name, "18-above"

    "not-empty": (self, opts, element, name) ->
      input = element.find(":input")
      match = undefined
      unless input.get(0).disabled
        match = input.val() isnt ""
        if input.is(':checkbox')
          match = input.is(":checked")
      else
        match = true
      handle_error self, match, name, "not-empty"

    "password-length": (self, opts, element, name) ->
      input = element.find(":input:eq(0)")
      if input.val().toString() isnt ""
        match = (input.val().toString().length >= 8 and input.val().toString().length <= 40)
        handle_error self, match, name, "password-length"
      else
        handle_error self, true, name, "password-length"

    "zip-length": (self, opts, element, name) ->
      input = element.find(":input:eq(0)")
      if input.val().toString() isnt ""
        match = (input.val().toString().length == 5)
        handle_error self, match, name, "zip-length"
      else
        handle_error self, true, name, "zip-length"

    "illegal-password": (self, opts, element, name) ->
      input = element.find(":input:eq(0)")
      reg_exp = /^[0-9a-zA-Z_]{4,40}$/
      match = true
      if input.val().length > 0
        input.each ->
          match = match and $(this).val().match(reg_exp)  unless @disabled
      handle_error self, match, name, "illegal-password"

    confirmation: (self, opts, element, name) ->
      password = self.find("." + classes.name + "_password input")
      password_confirmation = element.find(":input:eq(0)")
      if password.val().toString() isnt ""
        match = (password.val().toString() is password_confirmation.val().toString())
        handle_error self, match, name, "confirmation"
      else
        handle_error self, true, name, "confirmation"

    "correct-email-format": (self, opts, element, name) ->
      input = element.find(":input:eq(0)")
      reg_exp = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
      match = true
      input.each ->
        match = match and $(this).val().match(reg_exp)  unless @disabled

      handle_error self, match, name, "correct-email-format"

    "correct-email-format-empty": (self, opts, element, name) ->
      input = element.find(":input:eq(0)")
      reg_exp = /^$|\S+@\S+$/i
      match = true
      input.each ->
        match = match and $(this).val().match(reg_exp)  unless @disabled

      handle_error self, match, name, "correct-email-format-empty"

#    "correct-date": (self, opts, element, name) ->
#      input = element.find(":input")
#      day = undefined
#      month = undefined
#      year = undefined
#      match = undefined
#      input.each ->
#        that = $(this)
#        name = that.attr("name")
#        if name.match(/\(3i\)/)
#          day = that.val()
#        else if name.match(/\(2i\)/)
#          month = that.val() - 1
#        else year = that.val()  if name.match(/\(1i\)/)
#
#      try
#        date = new Date(year, month, day)
#        match = (parseInt(date.getFullYear(), 10) is parseInt(year, 10) and parseInt(date.getMonth(), 10) is parseInt(month, 10) and parseInt(date.getDate(), 10) is parseInt(day, 10))
#      catch exception
#        match = false
#      handle_error self, match, name, "correct-date"

  remote_validations =
    "unique-email_condition": (self, element) ->
      input = element.find(":input:eq(0)").get(0)
      uuid = self.find("#user_uuid").val()
      if input and input.value.toString() isnt ""
        [ true,
          email: input.value
          uuid: uuid
        ]
      else
        hide_error self, "email", "unique-email"
        [ false, {} ]

    "unique-email": (self, opts, element, name, data) ->
      if data.email_exists is true
        self.find("." + classes.error + "_" + name + "_unique-email").html("That email address is already registered. Please " + '<a class="open-sign-in-pnl sso-sign-in b-sso-login" href="http://www.ivillage.com/user/sign-in">login</a>' + " or use a different email address.")
#        self.find("." + classes.error + "_" + name + "_unique-email").html("Sorry, this email is already registered. If it is your email, " + "and you are registered in NBC network, you can use " + '<a class="open-sign-in-pnl sso-sign-in b-sso-login" href="http://www.ivillage.com/user/sign-in">login</a> ' + "form for logging in'")
      handle_error self, (data.email_exists is false), name, "unique-email"

    "unique-nick_condition": (self, element) ->
      input = element.find(":input:eq(0)").get(0)
      uuid = self.find("#user_uuid").val()
      if input and input.value.toString() isnt ""
        [ true,
          nick: input.value
          uuid: uuid
        ]
      else
        hide_error self, "nick", "unique-nick"
        [ false, {} ]

    "unique-nick": (self, opts, element, name, data) ->
      if data.nick_exists is true
        self.find("." + classes.error + "_" + name + "_unique-nick").html("This username is already taken by someone else. Please specify another one")

      handle_error self, (data.nick_exists is false), name, "unique-nick"

    "existed-email_condition": (self, element) ->
      input = element.find(":input:eq(0)").get(0)
      if input and input.value.toString() isnt ""
        [ true,
          email: input.value
        ]
      else
        hide_error self, "email", "existed-email"
        [ false, {} ]

    "existed-email": (self, opts, element, name, data) ->
      handle_error self, (data.email_exists isnt "false"), name, "existed-email"


  get_types = (element_classes) ->
    types = []
    type_reg_exp = new RegExp(classes.type + "_([\\w\\-]+)")
    $.each element_classes, ->
      match = @match(type_reg_exp)
      types.push match[1]  if match
    types

  get_name = (element_classes) ->
    name = null
    name_reg_exp = new RegExp(classes.name + "_([\\w\\-]+)")
    $.each element_classes, ->
      match = @match(name_reg_exp)
      name = match[1]  if match
    name

  iterate_through_every_type_of_every_element =  (elements, callback) ->
    $.each elements, ->
      element = $(this)
      element_classes = element.attr("class").split(" ")
      name = get_name(element_classes)
      types = get_types(element_classes)
      if types.length > 0
        $.each types, ->
          callback element, name, this
          return

  validate_locally = (self, opts, elements) ->
    overall_result = true
    iterate_through_every_type_of_every_element elements, (element, name, type) ->
      if local_validations[type]
        result = local_validations[type](self, opts, element, name)
        overall_result = overall_result and result
    overall_result

  make_remote_call = (self, opts, params) ->
    if params["email_unique-email"]
      self.find(".m-validations_type_unique-email").find("." + classes.spinner ).show()
    if params["nick_unique-nick"]
      self.find(".m-validations_type_unique-nick").find("." + classes.spinner ).show()
    result = null
    if window.location.href.indexOf("facebook") > -1
      host = "//contest-www.astrology.com"
      if window.location.pathname.indexOf("/photo-contests") > -1
        url = "#{host}/photo-contests/" + window.location.pathname.split('/')[7] + "/user/remote_validations.js"
      else
        url = "#{host}/user/remote_validations.js"
    else
      if window.location.pathname.indexOf("/photo-contests") > -1
        url = "/photo-contests/" + window.location.pathname.split('/')[2] + "/user/remote_validations.js"
      else
        url = "/user/remote_validations.js"

    $.ajax
      type: "GET"
      url: url
      data: params
      dataType: "json"
      async: false
      success: (json) ->
        result = json
#    spinner.hide()
    self.find("." + classes.spinner).hide()
    result

  get_params_for_remote_call = (self, opts, elements) ->
    should_make_remote_call = false
    params = {}
    iterate_through_every_type_of_every_element elements, (element, name, type) ->
      if remote_validations[type + "_condition"]
        result = remote_validations[type + "_condition"](self, element)
        if result[0]
          should_make_remote_call = true
          named_params = {}
          named_params[name + "_" + type] = result[1]
          params = $.extend({}, params, named_params)
    [ should_make_remote_call, params ]

  validate_remotely = (self, opts, elements) ->
    overall_result = true
    function_result = get_params_for_remote_call(self, opts, elements)
    should_make_remote_call = function_result[0]
    params = function_result[1]
    if should_make_remote_call
      call_result = make_remote_call(self, opts, params)
      iterate_through_every_type_of_every_element elements, (element, name, type) ->
        if remote_validations[type]
          data = call_result[name + "_" + type]
          if data
            result = remote_validations[type](self, opts, element, name, data)
            overall_result = overall_result and result
    overall_result

  validate_all = (self, opts) ->
    elements = self.find("." + classes.element)
    local_result = validate_locally(self, opts, elements)
    remote_result = validate_remotely(self, opts, elements)
    local_result and remote_result


  $.fn.m_validations = (options) ->
    opts = $.extend({}, $.fn.m_validations.defaults, options)
    @each ->
      self = $(this)
      self.submit ->
        validate_all self, opts

  $.m_validations_validate_all = (self, opts) ->
    opts = opts or {}
    validate_all self, opts

  $.fn.m_validations.defaults = {}
) jQuery
