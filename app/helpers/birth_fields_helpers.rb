module BirthFieldsHelpers

  def name_of_wrapper(options = {})
    klass = ""
    klass += " b-profile_#{options[:name]}"
    klass += " m-validations_name_#{options[:name]}"
    if options[:validation]
      validations = Array(options[:validation]).map{|v| "m-validations_type_#{v}"}.join(" ")
      klass += " m-validations_element #{validations}"
    end
    klass
  end

  def profile_wrapper(options = {})
    output =  "<div class='b-profile_row #{name_of_wrapper(options)}'>"
    output +=   "<div class='m-validations_border m-validations_border_#{options[:name]}'>"
    unless params[:facebook].nil?
      output +=     "<label for='#{options[:label_for]}' class='b-profile_row_label'><span class='b-profile_required_star'>*</span>#{options[:label]}</label>"
    else
      output +=     "<label for='#{options[:label_for]}' class='b-profile_row_label b-profile_row_label_#{@contest_name}'><span class='b-profile_required_star'>*</span>#{options[:label]}</label>"
    end
    output +=     "<div class='b-profile_row_field'>#{yield(options[:error])}</div>"
    if options[:error]
      output +=   "<ul class='b-profile_error_wrapper'>"
      options[:error].each do |key, value|
        classes =   "b-profile_error m-validations_error m-validations_error_#{options[:name]}_#{key}"
        output +=   "<li class='#{classes}'>#{value}</li>"
      end
      output +=   "</ul>"
    end
    output +=   "</div>"
    output += "</div>"
  end

  def your_name_profile_field(html_options = {})
    options = {
      :name => "your_name",
      :label => "Your Name:",
      :label_for => "your_name",
      :error => { "not-empty" => "We need to know who is requesting the reading." },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      text_field_tag(
        "your_name",
        @current_user.name_1,
        html_options.reverse_merge(:maxlength => "50", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def your_email_profile_field(html_options = {})
    options = {
      :name => "your_email",
      :label => "Your Email:",
      :label_for => "your_email",
      :error => { "correct-email-format" => "Your email address is not formated properly" },
      :validation => "correct-email-format"
    }
    profile_wrapper(options) do
      text_field_tag("your_email",
        @current_user.email,
        html_options.reverse_merge(
          :maxlength => "50",
          :class => "b-profile_row_field_272_text",
          :disabled => @current_user.logged_in?
        )
      )
    end.html_safe
  end

  def name_profile_field(f, number, html_options = {})
    options = {
      :name => "name_#{number}",
      :label => "Full Name:",
      :label_for => "name_#{number}",
      :error => { "not-empty" => "Please tell us your full name." },
      :validation => "not-empty"
    }
    if @current_user.logged_in?
      user_name = @current_user.first_name.nil? ? "#{@current_user.name_1}" : "#{@current_user.first_name} #{@current_user.last_name}"
    else
      user_name = @current_user.name_1
    end
    profile_wrapper(options) do
      f.text_field(
        "name_#{number}",
        html_options.reverse_merge(:value => user_name, :maxlength => "50", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def nick_profile_field(f, opts = {}, html_options = {})
    options = {
      :name => "nick",
      :label => "Nickname:",
      :label_for => "nick",
      :error => { "not-empty" => "Please tell us your nickname." },
      :validation => [ "not-empty" ]
    }
    if opts[:unique]
      options[:error]["unique-nick"] = "Your nickname is already taken by someone else. Please select another one"
      options[:validation] << "unique-nick"
    end
    profile_wrapper(options) do
      f.text_field(
        "nick",
        html_options.reverse_merge(:maxlength => "70", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def first_name_profile_field(f, opts = {}, html_options = {})
    options = {
      :name => "first_name",
      :label => "First Name:",
      :label_for => "first_name",
      :error => { "not-empty" => "Please enter first name." },
      :validation => [ "not-empty" ]
    }
    profile_wrapper(options) do
      f.text_field(
        "first_name",
        html_options.reverse_merge(:maxlength => "70", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def last_name_profile_field(f, opts = {}, html_options = {})
    options = {
      :name => "last_name",
      :label => "Last Name:",
      :label_for => "last_name",
      :error => { "not-empty" => "Please enter last name." },
      :validation => [ "not-empty" ]
    }
    profile_wrapper(options) do
      f.text_field(
        "last_name",
        html_options.reverse_merge(:maxlength => "70", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def negative_username_field(opts = {}, val = nil)
    options = {
      :name => "nick",
      :label => "Username:",
      :label_for => "user_nick",
      :error => { "not-empty" => "Username can't be empty." },
      :validation => [ "not-empty" ]
    }
    if opts[:unique]
      options[:error]["unique-nick"] = ""
      options[:validation] << "unique-nick"
    end
    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      output = "<div class='b-profile_spinner m-validations_spinner'></div>".html_safe
      output += text_field_tag("user[nick]", val , {:class => klass, :maxlength => 70, :readonly => opts[:readonly]})
    end.html_safe
  end

  def negative_first_name_field(opts = {}, val = nil)
    options = {
      :name => "first_name",
      :label => "First Name:",
      :label_for => "user_first_name",
      :error => { "not-empty" => "Please tell us your first name." },
      :validation => [ "not-empty" ]
    }
    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      text_field_tag("user[first_name]", val , {:class => klass, :maxlength => 70})
    end.html_safe
  end

  def birth_date_field(html_options = {}, val = nil)
    options = {
      :name => "birth_date",
      :label => "Birth Date:",
      :label_for => "user_birth_date_month",
      :error => { "18-above" => " You must be 18+ " },
      :validation => "18-above"
    }
    profile_wrapper(options) do
      date = val || Date.today
      output =  select_astro_month("user[birth_date_month]", date, html_options)
      output += select_astro_day("user[birth_date_day]", date, html_options)
      output += select_astro_year("user[birth_date_year]", date,
        html_options.reverse_merge(:start_year => 1910, :end_year => AppConfig['display_year'])
      )
    end.html_safe
  end

  def negative_residence_country_field(opts = {}, val=nil)
    options = {
      :name => "residence_country",
      :label => "Current Country:",
      :label_for => "user_country",
      :error => { "not-empty" => "Please pick your current country." },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      select_country("user[country]", val, opts)
    end.html_safe
  end

  def negative_gender_field(opts = {}, val=nil)
    options = {
      :name => "gender",
      :label => "Gender:",
      :label_for => "user_gender",
      :error => { "not-empty" => "Please specify your gender." },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      select_gender("user[gender]", val, opts)
    end.html_safe
  end

  def negative_checkbox_field(opts = {}, val=nil)
    options = {
      :name => "agree",
      :label => "#{check_box_tag("agree", 1, false)}Yes, I agree to the official contest #{link_to 'rules', 'http://www.ivillage.com/ivillage-best-family-vacation-photo-upload-contest-official-rules/8-a-474531'}".html_safe,
      :label_for => "agree",
      :error => { "not-empty" => "Please agree the terms." },
      :validation => [ "not-empty" ]
    }
    profile_wrapper(options) do
      #check_box_tag("agree", 1, false) #+ "Yes, I agree to the official contest #{link_to 'rules', 'http://www.ivillage.com/ivillage-best-family-vacation-photo-upload-contest-official-rules/8-a-474531'}".html_safe
    end.html_safe
  end

  def negative_last_name_field(opts = {}, val=nil)
    options = {
      :name => "last_name",
      :label => "Last Name:",
      :label_for => "user_last_name",
      :error => { "not-empty" => "Please tell us your last name." },
      :validation => [ "not-empty" ]
    }
    if opts[:unique]
      options[:error]["unique-nick"] = "Your last name is already taken by someone else. Please select another one"
      options[:validation] << "unique-nick"
    end
    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      #negative_text_field_tag(@user_captcha, :last_name, :value => val || @current_user.last_name, :class => klass, :maxlength => 70)
      text_field_tag("user[last_name]", val, {:class => klass, :maxlength => 70})
    end.html_safe
  end

  def negative_zip_profile_field(opts = {}, val=nil)
    options = {
      :name => "postal_code",
      :label => "Zip:",
      :label_for => "user_postal_code",
      :error => {
          "zip-length" => "Zip code should have 5 digits.",
          "not-empty" => "Please enter your zip code."
      },
      :validation => [ "not-empty", "zip-length" ]
    }

    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      #negative_text_field_tag(@user_captcha, :postal_code, :value => val || @current_user.postal_code, :class => klass, :maxlength => 70)
      text_field_tag("user[postal_code]", val, {:class => klass, :maxlength => 70})
    end.html_safe
  end

  def birthname_profile_field(f, number, html_options = {})
    options = {
      :name => "birth_name_#{number}",
      :label => "Full Name at Birth:",
      :label_for => "birth_name_#{number}",
      :error => { "not-empty" => "Please tell us your full name." },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      f.text_field(
        "birth_name_#{number}",
        html_options.reverse_merge(:maxlength => "50", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def email_profile_field(f, opts = {}, html_options = {})
    options = {
      :name => "email",
      :label => "Email:",
      :label_for => "email",
      :error => { "correct-email-format" => "Email address is not formated properly" },
      :validation => [ "correct-email-format" ]
    }
    if opts[:unique]
      options[:error]["unique-email"] = "Your email is already taken by someone else. Please select another one"
      options[:validation] << "unique-email"
    end
    profile_wrapper(options) do
      f.text_field("email",
        html_options.reverse_merge(
          :maxlength => "80",
          :class => "b-profile_row_field_272_text",
          :disabled => opts[:disabled]
        )
      )
    end.html_safe
  end

  def negative_email_profile_field(opts = {}, val=nil)
    options = {
      :name => "email",
      :label => "Email:",
      :label_for => "user_email",
      :error => { "correct-email-format" => "Invalid email address." },
      :validation => [ "correct-email-format" ]
    }
    if opts[:unique]
      # Text is assigned by m-validations JavaScript
      options[:error]["unique-email"] = ""
      options[:validation] << "unique-email"
    end
    if opts[:exists]
      options[:error]["existed-email"] = "This email is not registered."
      options[:validation] << "existed-email"
    end
    if opts[:empty].blank?
      options[:error]["not-empty"] = "Email can't be empty."
      options[:validation] << "not-empty"
    end
    #opts[:disabled] = "" unless opts[:disabled] == true
    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      output = "<div class='b-profile_spinner m-validations_spinner'></div>".html_safe
      #negative_text_field_tag(@user_captcha, :email, :value => val || @current_user.email, :class => klass, :maxlength => 80)
      output += text_field_tag("user[email]", val, {:class => klass, :maxlength => 80, :disabled => opts[:disabled]})
    end.html_safe
  end


  def password_profile_field(f, opts = {}, html_options = {})
    options = {
      :name => "password",
      :label => "Password:",
      :label_for => "password",
      :error => {
        "password-length" => "Password should be within 4..40 symbols",
        "illegal-password" => "Password should be within 4..40 legal characters"
      },
      :validation => [ "illegal-password", "password-length" ]
    }
    if opts[:empty].blank?
      options[:error]["not-empty"] = "Password can't be empty"
      options[:validation] << "not-empty"
    end
    profile_wrapper(options) do
      f.password_field(
        "password",
        html_options.reverse_merge(:maxlength => "40", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def negative_password_profile_field(opts = {})
    options = {
      :name => "password",
      :label => "Password:",
      :label_for => "user_password",
      :error => {
        "password-length" => "Password should be within 8..40 symbols.",
        "not-empty" => "You must enter a password.",
        "illegal-password" => "Password should be within 8..40 legal characters."
      },
      :validation => [ "password-length", "illegal-password", "not-empty" ]
    }
    if opts[:correct]
      options[:error]["correct-password"] = "Password is wrong."
      options[:validation] << "correct-password"
    end
    profile_wrapper(options) do
      password_field_tag("user[password]", @current_user.password, {:class => "b-profile_row_field_272_text", :maxlength => 40})
    end.html_safe
  end

  def password_confirmation_profile_field(f, html_options = {})
    options = {
      :name => "password_confirmation",
      :label => "Password Confirmation:",
      :label_for => "password_confirmation",
      :error => {
        "confirmation" => "Password confirmation doesn't match Password"
      },
      :validation => [ "confirmation" ]
    }
    profile_wrapper(options) do
      f.password_field(
        "password_confirmation",
        html_options.reverse_merge(:maxlength => "40", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def negative_password_confirmation_profile_field
    options = {
      :name => "password_confirmation",
      :label => "Password Confirmation:",
      :label_for => "user_password_confirmation",
      :error => {
        "confirmation" => "Password confirmation doesn't match Password",
        "illegal-password" => "Password should be within 4..40 legal characters"
      },
      :validation => [ "confirmation", "illegal-password" ]
    }
    profile_wrapper(options) do
      klass = "b-profile_row_field_272_text"
      #negative_password_field_tag(@user_captcha, :password_confirmation, :class => klass, :maxlength => 40)
      password_field_tag("user[password_confirmation]", @current_user.password_confirmation, {:class => klass, :maxlength => 40})
    end.html_safe
  end

  def gender_profile_field(f, html_options = {})
    options = {
        :name => "gender",
        :label => "Gender:",
        :error => {
            "not-empty" => "Please specify your Gender"
        },
        :validation => [ "not-empty"]
    }
    profile_wrapper(options) do
      select_gender("user[gender]", f.object.gender, html_options)
    end.html_safe
  end

  def birth_date_profile_field(f, html_options = {})
    options = {
        :name => "birth_date",
        :label => "Birth Date:",
        :error => {
            "not-empty" => "Please tell us your birth date",
            "correct-date" => "Your birth date is not on the calendar."
        },
        :validation => [ "not-empty", "correct-date" ]
    }
    profile_wrapper(options) do
      if f.object.birth_date != Date.today
        year_date = month_date = day_date = f.object.birth_date
      else
        year_date = month_date = day_date = Date.today
      end

      output =  select_astro_month("user[birth_date_month]", month_date, html_options)
      output += select_astro_day("user[birth_date_day]", day_date, html_options)
      output += select_astro_year(
          "user[birth_date_year]",
          year_date,
          html_options.reverse_merge(:start_year => 1910, :end_year => AppConfig['display_year'])
      )
    end.html_safe
  end

  def date_profile_field(f, number, html_options = {})
    options = {
      :name => "birth_date_#{number}",
      :label => "Birth Date:",
      :error => {
        "not-empty" => "Please tell us your birth date",
        "correct-date" => "Your birth date is not on the calendar."
      },
      :validation => [ "not-empty", "correct-date" ]
    }
    profile_wrapper(options) do
      if params['year'] || params['month'] || params['day'] || params['user[birth_date_1(1i)]'] || params['user[birth_date_1(2i)]'] || params['user[birth_date_1(3i)]']
        year_date = Date.new((params['user[birth_date_1(1i)]'] || params['year']).to_i, 1, 1) rescue nil
        month_date = Date.new(2000, (params['user[birth_date_1(2i)]'] || params['month']).to_i, 1) rescue nil
        day_date = Date.new(2000, 1, (params['user[birth_date_1(3i)]'] || params['day']).to_i) rescue nil
      elsif f.object.personalized_date(number) != Date.today
        year_date = month_date = day_date = f.object.personalized_date(number)
      else
        year_date = month_date = day_date = nil
      end

      output =  select_astro_month("user[birth_date_#{number}(2i)]", month_date, html_options)
      output += select_astro_day("user[birth_date_#{number}(3i)]", day_date, html_options)
      output += select_astro_year(
        "user[birth_date_#{number}(1i)]",
        year_date,
        html_options.reverse_merge(:start_year => 1910, :end_year => AppConfig['display_year'])
      )
    end.html_safe
  end

  def date_profile_field_bg(f, number, html_options = {})
    options = {
      :name => "birth_date_#{number}",
      :label => "Birth Date:",
      :error => {
        "not-empty" => "Please tell us your birth date",
        "correct-date" => "Your birth date is not on the calendar."
      },
      :validation => [ "not-empty", "correct-date" ]
    }
    profile_wrapper(options) do
      if params['year'] || params['month'] || params['day'] || params['user[birth_date_1(1i)]'] || params['user[birth_date_1(2i)]'] || params['user[birth_date_1(3i)]']
        year_date = Date.new((params['user[birth_date_1(1i)]'] || params['year']).to_i, 1, 1) rescue nil
        month_date = Date.new(2000, (params['user[birth_date_1(2i)]'] || params['month']).to_i, 1) rescue nil
        day_date = Date.new(2000, 1, (params['user[birth_date_1(3i)]'] || params['day']).to_i) rescue nil
      elsif f.object.personalized_date(number) != Date.today
        year_date = month_date = day_date = f.object.personalized_date(number)
      else
        year_date = month_date = day_date = nil
      end

      output =  "<div class='bg_date_select'>"+select_astro_month("user[birth_date_#{number}(2i)]", month_date, html_options)+"</div>"
      output += "<div class='bg_date_select'>"+select_astro_day("user[birth_date_#{number}(3i)]", day_date, html_options)+"</div>"
      output += "<div class='bg_date_select'>"+select_astro_year(
        "user[birth_date_#{number}(1i)]",
        year_date,
        html_options.reverse_merge(:start_year => 1910, :end_year => AppConfig['display_year'])
      )+"</div>"
    end.html_safe
  end

  def time_profile_field(f, number, html_options = {})
    options = { :name => "birth_time_#{number}", :label => "Birth Time" }
    output = "<div class='m-tooltip_square'>"
    output += "<div class='m-tooltip_square_target'>"
    output += profile_wrapper(options) do
      time = f.object.personalized_time(number)
      inner_output = select_astro_time(number, time, html_options.reverse_merge(:class => "b-profile_row"))
      note =  "<div class='m-tooltip_square_source'>Don't have your birth time? "
      note += "You can still receive a reading with just your birth date and place of birth, "
      note += "however, it will lack in-depth astrological details.  If you do not have "
      note += "your time of birth, we recommend you use 12:00 noon since this is a practice "
      note += "followed by astrologers when time of birth is not known and will give you a "
      note += "more comprehensive reading than a reading without a time of birth.</div>"
      "#{inner_output}#{note}"
    end
    output += "</div>"
    output += "</div>"
    output.html_safe
  end

  def time_profile_field_bg(f, number, html_options = {})
    options = { :name => "birth_time_#{number}", :label => "Birth Time" }
    output = "<div class='m-tooltip_square'>"
    output += "<div class='m-tooltip_square_target'>"
    output += profile_wrapper(options) do
      time = f.object.personalized_time(number)
      inner_output = select_astro_time_bg(number, time, html_options.reverse_merge(:class => "b-profile_row"))
      note =  "<div class='m-tooltip_square_source'>Don't have your birth time? "
      note += "You can still receive a reading with just your birth date and place of birth, "
      note += "however, it will lack in-depth astrological details.  If you do not have "
      note += "your time of birth, we recommend you use 12:00 noon since this is a practice "
      note += "followed by astrologers when time of birth is not known and will give you a "
      note += "more comprehensive reading than a reading without a time of birth.</div>"
      "#{inner_output}#{note}"
    end
    output += "</div>"
    output += "</div>"
    output.html_safe
  end

  def city_profile_field(f, prefix, number, html_options = {})
    options = {
      :name => "#{prefix}_city_#{number}",
      :label => "#{prefix.capitalize} City",
      :label_for => "user_#{prefix}_city_#{number}",
      :error => { "not-empty" => "Please tell us the city" },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      f.text_field("#{prefix}_city_#{number}", html_options.reverse_merge(:class => "b-profile_row_field_272_text city"))
    end.html_safe
  end

  def state_profile_field(f, prefix, number, html_options = {})
    options = {
      :name => "#{prefix}_state_#{number}",
      :label => "#{prefix.capitalize} State",
      :label_for => "user_#{prefix}_state_#{number}",
      :error => { "not-empty_if-us" => "Please tell us the state you were born in" },
      :validation => "not-empty_if-us"
    }
    profile_wrapper(options) do
      state = select_state(
        "user[#{prefix}_state_#{number}]",
        f.object.send("#{prefix}_state_#{number}"),
        html_options.reverse_merge(:class => "state")
      )
      note = "<span class='b-profile_row_note'>(US only)</span>"
      "#{state}#{note}"
    end.html_safe
  end

  def country_profile_field(f, prefix, number, html_options = {})
    options = {
      :name => "#{prefix}_country_#{number}",
      :label => "#{prefix.capitalize} Country",
      :label_for => "#{prefix}_birth_country_#{number}",
      :error => { "not-empty" => "Please pick your #{prefix} country" },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      select_country(
        "user[#{prefix}_country_#{number}]",
        f.object.send("#{prefix}_country_#{number}"),
        html_options.reverse_merge(:class => "country")
      )
    end.html_safe
  end

  def residence_country_profile_field(f, html_options = {}, val = nil)
    options = {
      :name => "residence_country",
      :label => "Current Country:",
      :label_for => "user_residence_country",
      :error => { "not-empty" => "Please pick your current country" },
      :validation => "not-empty"
    }
    profile_wrapper(options) do
      select_country("user[country]", val || f.object.country, html_options)
    end.html_safe
  end

  def accurate_place_profile_field(f, prefix, number, html_options = {})
    options = {
      :name => "accurate-#{prefix}_place_#{number}",
      :label => html_options.delete(:name) || "Correct Place",
      :label_for => "user_accurate_#{prefix}_place_#{number}",
      :error => {
        "multiple-locations" => "Our atlas database shows multiple cities with the same " +
          "name as your city of birth. Please select the correct city for you from the choices given."
      }
    }
    output = profile_wrapper(options) do
      inner_output = "<div class='m-validations_accurate-place_field'>"
      unless f.object.send("multiple_#{prefix}_locations_#{number}").blank?
        inner_output += select_tag(
          "user[accurate_#{prefix}_place_#{number}]",
          options_for_select(f.object.send("multiple_#{prefix}_locations_#{number}")),
          html_options
        )
      end
      inner_output += "</div>"
    end
    # This is for stupid IE6, it shows <option> tags as usual text if there was a hidden block
    # before <select>. So, we just add visible empty <div> container to avoid such bug
    output += "<div></div>"
    output.html_safe
  end


  def zip_profile_field(f, html_options = {}, val = nil)
    options = {
      :name => "zip",
      :label => "Zip Code:",
      :label_for => "zip",
      :error => { "not-empty" => "Please tell correct post code" },
      :validation => "not-empty"
    }
    if val.nil?
      text_field_hash = {:size => "10", :class => "b-profile_row_field_60_text"}
    else
      text_field_hash = {:size => "10", :class => "b-profile_row_field_60_text", :value => val}
    end
    profile_wrapper(options) do
      field = f.text_field(
        "postal_code",
        html_options.reverse_merge(text_field_hash)
      )
      note = "<span class='b-profile_row_note'>(US only)</span>"
      "#{field}"
    end.html_safe
  end

  #def newsletter_profile_field(f, html_options = {}, val = false, number = 1)
  #  options = {
  #      :name => "newsletter_#{number}",
  #      :label => "Zip Code",
  #      :label_for => "user_newsletter_#{number}"
  #  }
  #  profile_wrapper(options) do
  #    field = f.check_box_field(
  #        "postal_code",
  #        html_options
  #    )
  #    "#{field}"
  #  end.html_safe
  #end

  def forecast_start_date_profile_field(html_options = {})
    options = {
      :name => "forecast_start_date",
      :label => "Forecast Start Date",
      :error => { "correct-date" => "Your birth date is not on the calendar." },
      :validation => [ "correct-date" ]
    }
    profile_wrapper(options) do
      today = Date.today
      output =  select_astro_month("fmonth_(2i)", today, html_options)
      output += select_astro_day("fday_(3i)", today, html_options)
      output += select_astro_year("fyear_(1i)", today, html_options)
    end.html_safe
  end

  def save_person_data_profile_field(f, number, html_options = {})
    options = {
      :name => "save_person_data_#{number}",
      :label => "Save birth data",
      :label_for => "user_save_person_data_#{number}"
    }
    profile_wrapper(options) do
      output = f.check_box("save_person_data_#{number}", html_options)
      output += f.label("save_person_data_#{number}", "Save data for 2nd person for future readings.")
    end.html_safe
  end

  def submit_profile_field(label = "Save", html_options = {})
    output = "<div class='b-profile_row b-profile_row_submit'>"
    output += submit_tag(
      label,
      html_options.reverse_merge(:class => "b-profile_row_submit_button m-form_button m-form_button_80")
    )
    #output += "<div class='b-profile_spinner m-validations_spinner'></div>"
    output += "</div>"
    output.html_safe
  end

  def entry_name_field(html_options = {})
    options = {
        :name => "entryname",
        :label => "Image Title:",
        :label_for => "entryname",
        :error => { "not-empty" => "Image title is required." },
        :validation => "not-empty"
    }
    profile_wrapper(options) do
      text_field_tag(
          "entryname",
          "",
          html_options.reverse_merge(:maxlength => "50", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def image_description_field(html_options = {})
    options = {
        :name => "description",
        :label => "Image Description:",
        :label_for => "description",
        :error => { "not-empty" => "Image Description is required." },
        :validation => "not-empty"
    }
    profile_wrapper(options) do
      text_field_tag(
          "description",
          "",
          html_options.reverse_merge(:maxlength => "50", :class => "b-profile_row_field_272_text")
      )
    end.html_safe
  end

  def image_file_field(html_options = {})
    options = {
        :name => "image",
        :label => "Photo:",
        :label_for => "image",
        :instructions => "File size limit of 3MB. Only .JPEG/.JPG and .GIF format accepted",
        :error => {
            "not-empty" => "Image is required.",
            "file-size" => "Image must be smaller than 3 MB.",
            "file-type" => "Only JPEG/JPG/GIF Images are allowed."        },
        :validation =>[ "not-empty", "file-type", "file-size"]
    }
    profile_wrapper(options) do
      "#{file_field_tag(
          "image",
          html_options.reverse_merge(:maxlength => "100",:accept => 'image/jpeg,image/jpg,image/gif')
      )}<div style='float:left;width:350px;'> File size limit of 3MB. Only .JPEG/.JPG and .GIF formats accepted. </div>"
    end.html_safe
  end

  def image_category_field(html_options = {})
    options = {
        :name => "category",
        :label => "Category:",
        :label_for => "category",
        :error => {
            "not-empty" => "Please specify the category"
        },
        :validation => [ "not-empty"]
    }
    profile_wrapper(options) do
      select_image_category("category", "", html_options)
    end.html_safe
  end
end