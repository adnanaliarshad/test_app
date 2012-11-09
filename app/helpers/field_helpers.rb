# encoding: utf-8

module FieldHelpers

  def styled_text_field_tag(name, value, options = {})
    example = options.delete(:example)
    output =  ""
    output += "<div class='m-validations_border'>" unless options[:without_border]
    output += "<div class='m-form_text_left'>"
    output +=   "<div class='m-form_text_right'>"
    output +=     "<label class='m-clear-inputs_description'>#{h(example)}</label>" unless example.blank?
    output +=     text_field_tag(name, value, options)
    output +=  "</div>"
    output += "</div>"
    output += "</div>" unless options[:without_border]
    output.html_safe
  end

  def user_birth_date_tag(f, number = 1, options = {})
    default = (Date.civil(1980, Date.today.month, Date.today.day) rescue Date.today)
    order = [ :month, :day, :year ]
    options.reverse_merge!(:default_date => default, :order => order, :start_year => 1900, :end_year => Date.today.year)
    f.date_select("birth_date_#{number}", options)
  end

  def user_astro_birth_date_tag(f, number = 1, options = {})
    date = f.object.birth_date_1
    opts = { :start_year => 1910, :end_year => AppConfig['display_year'] }
    output =  select_astro_month("user[birth_date_1(2i)]", date)
    output += select_astro_day("user[birth_date_1(3i)]", date)
    output += select_astro_year("user[birth_date_1(1i)]", date, opts)
    output.html_safe
  end

  def select_astro_time(number, time, options = {})
    inner_output = hidden_field_tag("user[birth_time_#{number}(1i)]", 2000)
    inner_output += hidden_field_tag("user[birth_time_#{number}(2i)]", 1)
    inner_output += hidden_field_tag("user[birth_time_#{number}(3i)]", 1)
    klass = options.delete(:class)
    inner_output += select_astro_hour(
      "user[birth_time_#{number}(4i)]",
      time,
      options.reverse_merge(:class => "#{klass}_hour")
    )
    inner_output += ":"
    inner_output += select_astro_minute(
      "user[birth_time_#{number}(5i)]",
      time,
      options.reverse_merge(:class => "#{klass}_minute")
    )
    inner_output += select_astro_ampm(
      "user[birth_time_#{number}(7i)]",
      time,
      options.reverse_merge(:class => "#{klass}_ampm")
    )
  end

  def select_astro_time_bg(number, time, options = {})
    inner_output = hidden_field_tag("user[birth_time_#{number}(1i)]", 2000)
    inner_output += hidden_field_tag("user[birth_time_#{number}(2i)]", 1)
    inner_output += hidden_field_tag("user[birth_time_#{number}(3i)]", 1)
    klass = options.delete(:class)
    inner_output += select_astro_hour(
      "user[birth_time_#{number}(4i)]",
      time,
      options.reverse_merge(:class => "#{klass}_hour")
    )
    inner_output += ":"
    inner_output += select_astro_minute(
      "user[birth_time_#{number}(5i)]",
      time,
      options.reverse_merge(:class => "#{klass}_minute")
    )
    inner_output += select_astro_ampm(
      "user[birth_time_#{number}(7i)]",
      time,
      options.reverse_merge(:class => "#{klass}_ampm")
    )
  end

  # Replace of usual select_year helper. If user already selected his
  # birthdate, it sets selected value to his birthyear, otherwise it
  # adds additional <option> tag before 1960 year with value = ''
  # and text = '-Year-' and makes the tag selected.
  def select_astro_year(method, date, options = {})
    start_year = options.delete(:start_year) || 1910
    end_year = options.delete(:end_year) || AppConfig['display_year']
    select_options = year_select_options(start_year, end_year, date ? date.year : nil)
    select_tag(method, select_options.html_safe, options)
  end

  # Replace of usual select_month helper. If user already selected his
  # birthdate, it sets selected value to his birthmonth, otherwise it
  # adds additional <option> tag before the first <option> tag with
  # value ='' and text = '-Month-'
  def select_astro_month(method, date, options = {})
    select_options = month_select_options(date ? date.month : nil)
    select_tag(method, select_options.html_safe, options)
  end

  # Replace of usual select_day helper. Works like select_astro_month
  def select_astro_day(method, date, options = {})
    select_options = day_select_options(date ? date.day : nil)
    select_tag(method, select_options.html_safe, options)
  end

  # Replace of usual select_hour helper. Works like select_astro_month
  def select_astro_hour(method, time, options = {})
    selected = convert_hour_24_to_12(time.hour) if time
    select_options = hour_select_options(selected)
    select_tag(method, select_options.html_safe, options)
  end

  # Replace of usual select_minute helper. Works like select_astro_month
  def select_astro_minute(method, time, options = {})
    select_options = minute_select_options(time ? time.min : nil)
    select_tag(method, select_options.html_safe, options)
  end

  def select_astro_ampm(method, time, options = {})
    selected = (period_for_hour(time.hour)) if time
    select_options = ampm_select_options(selected)
    select_tag(method, select_options.html_safe, options)
  end

  # Build array of years - options for select tag, then cache it.
  def year_select_options(start_year, end_year, year)
    if !@year_select_options || !@year_select_options["#{start_year}_#{end_year}"]
      @year_select_options ||= {}
      @year_select_options["#{start_year}_#{end_year}"] = (start_year..end_year).map do |y|
        "<option value='#{y}'>#{y}</option>"
      end.join("")
    end
    set_selected_year(@year_select_options["#{start_year}_#{end_year}"], year)
  end

  # Build array of months - options for select tag, then cache it.
  def month_select_options(month)
    unless @month_select_options
      # Use array instead of hash because order of months is imporant
      months = [
        [ "January", 1 ],
        [ "February", 2 ],
        [ "March", 3 ],
        [ "April", 4 ],
        [ "May", 5 ],
        [ "June", 6 ],
        [ "July", 7 ],
        [ "August", 8 ],
        [ "September", 9 ],
        [ "October", 10 ],
        [ "November", 11 ],
        [ "December", 12 ]
      ]
      @month_select_options = months.map do |values|
        "<option value='#{values[1]}'>#{values[0]}</option>"
      end.join("")
    end
    set_selected_option(@month_select_options, month, "-Month-")
  end

  # Build array of days - options for select tag, then cache it.
  def day_select_options(day)
    unless @day_select_options
      @day_select_options = (1..31).map do |d|
          "<option value='#{d}'>#{d}</option>"
      end.join("")
    end
    set_selected_option(@day_select_options, day, "-Day-")
  end

  # Build array of years - options for select tag, then cache it.
  def hour_select_options(hour)
    unless @hour_select_options
      @hour_select_options = (1..12).map do |h|
        "<option value='#{"%.2i" % h}'>#{"%.2i" % h}</option>"
      end.join("")
    end
    set_selected_option(@hour_select_options, hour ? "%.2i" % hour : nil, "-Hour-")
  end

  # Build array of years - options for select tag, then cache it.
  def minute_select_options(minute)
    unless @minute_select_options
      @minute_select_options = (0..59).map do |m|
        "<option value='#{"%.2i" % m}'>#{"%.2i" % m}</option>"
      end.join("")
    end
    set_selected_option(@minute_select_options, minute ? "%.2i" % minute : nil, "-Minute-")
  end

  # Build array of years - options for select tag, then cache it.
  def ampm_select_options(ampm)
    unless @ampm_select_options
      @ampm_select_options = ['am', 'pm'].map do |m|
        "<option value='#{m}'>#{m.upcase}</option>"
      end.join("")
    end
    set_selected_option(@ampm_select_options, ampm, "-AM/PM-")
  end


  def set_selected_year(options, year)
    if year
      options.gsub(" value='#{year}'", " value='#{year}' selected='selected'")
    else
      options.gsub("<option value='1960'>1960</option>", "<option value='' selected='selected'>-Year-</option><option value='1960'>1960</option>")
    end
  end

  def set_selected_option(options, value, title)
    if value
      options.gsub(" value='#{value}'", " value='#{value}' selected='selected'")
    else
      "<option value='' selected='selected'>#{title.to_s}</option>" + options.to_s
    end
  end

  def period_for_hour(hour)
    hour >= 0 && hour <= 11 ? "am" : "pm"
  end

  def convert_hour_24_to_12(hour)
    if hour == 0 || hour == 12
      12
    elsif hour > 12
      hour - 12
    else
      hour
    end
  end


  def select_state(name, selected_state = nil, options = {})
    states = [
      ["-State-", ""],
      ["Alabama","Alabama"],
      ["Alaska","Alaska"],
      ["Arizona","Arizona"],
      ["Arkansas","Arkansas"],
      ["California","California"],
      ["Colorado","Colorado"],
      ["Connecticut","Connecticut"],
      ["Delaware","Delaware"],
      ["District of Columbia","District of Columbia"],
      ["Florida","Florida"],
      ["Georgia","Georgia"],
      ["Hawaii","Hawaii"],
      ["Idaho","Idaho"],
      ["Illinois","Illinois"],
      ["Indiana","Indiana"],
      ["Iowa","Iowa"],
      ["Kansas","Kansas"],
      ["Kentucky","Kentucky"],
      ["Louisiana","Louisiana"],
      ["Maine","Maine"],
      ["Maryland","Maryland"],
      ["Massachusetts","Massachusetts"],
      ["Michigan","Michigan"],
      ["Minnesota","Minnesota"],
      ["Mississippi","Mississippi"],
      ["Missouri","Missouri"],
      ["Montana","Montana"],
      ["Nebraska","Nebraska"],
      ["Nevada","Nevada"],
      ["New Hampshire","New Hampshire"],
      ["New Jersey","New Jersey"],
      ["New Mexico","New Mexico"],
      ["New York","New York"],
      ["North Carolina","North Carolina"],
      ["North Dakota","North Dakota"],
      ["Ohio","Ohio"],
      ["Oklahoma","Oklahoma"],
      ["Oregon","Oregon"],
      ["Pennsylvania","Pennsylvania"],
      ["Puerto Rico","Puerto Rico"],
      ["Rhode Island","Rhode Island"],
      ["South Carolina","South Carolina"],
      ["South Dakota","South Dakota"],
      ["Tennessee","Tennessee"],
      ["Texas","Texas"],
      ["Utah","Utah"],
      ["Vermont","Vermont"],
      ["Virginia","Virginia"],
      ["Washington","Washington"],
      ["West Virginia","West Virginia"],
      ["Wisconsin","Wisconsin"],
      ["Wyoming","Wyoming"]
    ]
    select_tag(name, options_for_select(states, selected_state), options)
  end
  def select_country(name, selected_country = nil, options = {})
    countries = [
      ["United States","1"],
      ["Canada","2"],
      ["United Kingdom","223"],
      ["Afghanistan","4"],
      ["Albania","5"],
      ["Algeria","6"],
      ["Andorra","7"],
      ["Angola","8"],
      ["Anguilla","9"],
      ["Antigua & Barbuda","10"],
      ["Argentina","11"],
      ["Armenia","12"],
      ["Australia","13"],
      ["Austria","14"],
      ["Azerbaijan","15"],
      ["Bahamas","16"],
      ["Bahrain","17"],
      ["Bangladesh","18"],
      ["Barbados","19"],
      ["Belarus","20"],
      ["Belgium","Belgium"],
      ["Belize","Belize"],
      ["Benin","Benin"],
      ["Bermuda","Bermuda"],
      ["Bhutan","Bhutan"],
      ["Bolivia","Bolivia"],
      ["Bosnia & Herzegovina","Bosnia & Herzegovina"],
      ["Botswana","Botswana"],
      ["Brazil","Brazil"],
      ["Brunei","Brunei"],
      ["Bulgaria","Bulgaria"],
      ["Burkina Faso","Burkina Faso"],
      ["Burundi","Burundi"],
      ["Cambodia","Cambodia"],
      ["Cameroon","Cameroon"],
      ["Canada","Canada"],
      ["Cape Verde","Cape Verde"],
      ["Cayman Islands","Cayman Islands"],
      ["Central African Republic","Central African Republic"],
      ["Chad","Chad"],
      ["Chile","Chile"],
      ["China","China"],
      ["Colombia","Colombia"],
      ["Comoros","Comoros"],
      ["Congo Democratic Republic","Congo Democratic Republic"],
      ["Congo","Congo"],
      ["Cook Islands","Cook Islands"],
      ["Costa Rica","Costa Rica"],
      ["Croatia","Croatia"],
      ["Cuba","Cuba"],
      ["Cyprus","Cyprus"],
      ["Czech Republic","Czech Republic"],
      ["Denmark","Denmark"],
      ["Djibouti","Djibouti"],
      ["Dominica","Dominica"],
      ["Dominican Republic","Dominican Republic"],
      ["East Timor","East Timor"],
      ["Ecuador","Ecuador"],
      ["Egypt","Egypt"],
      ["El Salvador","El Salvador"],
      ["England","United Kingdom"],
      ["Equatorial Guinea","Equatorial Guinea"],
      ["Eritrea","Eritrea"],
      ["Estonia","Estonia"],
      ["Ethiopia","Ethiopia"],
      ["Faeroe Islands","Faeroe Islands"],
      ["Falkland Islands","Falkland Islands"],
      ["Fiji","Fiji"],
      ["Finland","Finland"],
      ["France","France"],
      ["French Guiana","French Guiana"],
      ["French Polynesia","French Polynesia"],
      ["Gabon","Gabon"],
      ["Gambia","Gambia"],
      ["Georgia","Georgia"],
      ["Germany","Germany"],
      ["Ghana","Ghana"],
      ["Gibraltar","Gibraltar"],
      ["Greece","Greece"],
      ["Greenland","Greenland"],
      ["Grenada","Grenada"],
      ["Guadeloupe","Guadeloupe"],
      ["Guam","Guam"],
      ["Guatemala","Guatemala"],
      ["Guernsey","Guernsey"],
      ["Guinea","Guinea"],
      ["Guinea-Bissau","Guinea-Bissau"],
      ["Guyana","Guyana"],
      ["Haiti","Haiti"],
      ["Honduras","Honduras"],
      ["Hungary","Hungary"],
      ["Iceland","Iceland"],
      ["India","India"],
      ["Indonesia","Indonesia"],
      ["Iran","Iran"],
      ["Iraq","Iraq"],
      ["Ireland","Ireland"],
      ["Israel","Israel"],
      ["Italy","Italy"],
      ["Ivory Coast","Ivory Coast"],
      ["Jamaica","Jamaica"],
      ["Japan","Japan"],
      ["Jersey","Jersey"],
      ["Jordan","Jordan"],
      ["Kazakhstan","Kazakhstan"],
      ["Kenya","Kenya"],
      ["Kiribati","Kiribati"],
      ["Korea, North","Korea, North"],
      ["Korea, South","Korea, South"],
      ["Kuwait","Kuwait"],
      ["Kyrgyzstan","Kyrgyzstan"],
      ["Laos","Laos"],
      ["Latvia","Latvia"],
      ["Lebanon","Lebanon"],
      ["Lesotho","Lesotho"],
      ["Liberia","Liberia"],
      ["Libya","Libya"],
      ["Liechtenstein","Liechtenstein"],
      ["Lithuania","Lithuania"],
      ["Luxembourg","Luxembourg"],
      ["Macedonia","Macedonia"],
      ["Madagascar","Madagascar"],
      ["Malawi","Malawi"],
      ["Malaysia","Malaysia"],
      ["Maldives","Maldives"],
      ["Mali","Mali"],
      ["Malta","Malta"],
      ["Man, Isle of","Man, Isle of"],
      ["Marshall Islands","Marshall Islands"],
      ["Martinique","Martinique"],
      ["Mauritania","Mauritania"],
      ["Mauritius","Mauritius"],
      ["Mayotte","Mayotte"],
      ["Mexico","Mexico"],
      ["Micronesia","Micronesia"],
      ["Midway Islands","Midway Islands"],
      ["Moldova","Moldova"],
      ["Monaco","Monaco"],
      ["Mongolia","Mongolia"],
      ["Montserrat","Montserrat"],
      ["Morocco","Morocco"],
      ["Mozambique","Mozambique"],
      ["Myanmar","Myanmar"],
      ["Namibia","Namibia"],
      ["Nauru","Nauru"],
      ["Nepal","Nepal"],
      ["Netherlands Antilles","Netherlands Antilles"],
      ["Netherlands","Netherlands"],
      ["New Caledonia","New Caledonia"],
      ["New Zealand","New Zealand"],
      ["Nicaragua","Nicaragua"],
      ["Niger","Niger"],
      ["Nigeria","Nigeria"],
      ["Niue","Niue"],
      ["Norfolk Island","Norfolk Island"],
      ["Northern Ireland","United Kingdom"],
      ["Northern Mariana Islands","Northern Mariana Islands"],
      ["Norway","Norway"],
      ["Oman","Oman"],
      ["Pakistan","Pakistan"],
      ["Palau","Palau"],
      ["Panama","Panama"],
      ["Papua New Guinea","Papua New Guinea"],
      ["Paraguay","Paraguay"],
      ["Peru","Peru"],
      ["Philippines","Philippines"],
      ["Pitcairn","Pitcairn"],
      ["Poland","Poland"],
      ["Portugal","Portugal"],
      ["Puerto Rico","Puerto Rico"],
      ["Qatar","Qatar"],
      ["Reunion","Reunion"],
      ["Romania","Romania"],
      ["Russia","Russia"],
      ["Rwanda","Rwanda"],
      ["Saint Helena","Saint Helena"],
      ["Saint Kitts-Nevis","Saint Kitts-Nevis"],
      ["Saint Lucia","Saint Lucia"],
      ["Saint Pierre and Miquelon","Saint Pierre and Miquelon"],
      ["Saint Vincent and Grenadines","Saint Vincent and Grenadines"],
      ["Samoa, American","Samoa, American"],
      ["Samoa, Western","Samoa, Western"],
      ["San Marino","San Marino"],
      ["Sao Tome and Principe","Sao Tome and Principe"],
      ["Saudi Arabia","Saudi Arabia"],
      ["Scotland","United Kingdom"],
      ["Senegal","Senegal"],
      ["Seychelles","Seychelles"],
      ["Sierra Leone","Sierra Leone"],
      ["Singapore","Singapore"],
      ["Slovakia","Slovakia"],
      ["Slovenia","Slovenia"],
      ["Solomon Islands","Solomon Islands"],
      ["Somalia","Somalia"],
      ["South Africa","South Africa"],
      ["South Georgia","South Georgia"],
      ["Spain","Spain"],
      ["Sri Lanka","Sri Lanka"],
      ["Sudan","Sudan"],
      ["Suriname","Suriname"],
      ["Swaziland","Swaziland"],
      ["Sweden","Sweden"],
      ["Switzerland","Switzerland"],
      ["Syria","Syria"],
      ["Taiwan","Taiwan"],
      ["Tajikistan","Tajikistan"],
      ["Tanzania","Tanzania"],
      ["Thailand","Thailand"],
      ["Togo","Togo"],
      ["Tokelau Islands","Tokelau Islands"],
      ["Tonga","Tonga"],
      ["Trinidad and Tobago","Trinidad and Tobago"],
      ["Tunisia","Tunisia"],
      ["Turkey","Turkey"],
      ["Turkmenistan","Turkmenistan"],
      ["Turks and Caicos","Turks and Caicos"],
      ["Tuvalu","Tuvalu"],
      ["Uganda","Uganda"],
      ["Ukraine","Ukraine"],
      ["United Arab Emirates","United Arab Emirates"],
      ["United Kingdom","United Kingdom"],
      ["United States","US"],
      ["Uruguay","Uruguay"],
      ["Uzbekistan","Uzbekistan"],
      ["Vanuatu","Vanuatu"],
      ["Venezuela","Venezuela"],
      ["Vietnam","Vietnam"],
      ["Virgin Islands","Virgin Islands"],
      ["Wake Island","Wake Island"],
      ["Wales","Wales"],
      ["Wallis and Futuna","Wallis and Futuna"],
      ["Yemen","Yemen"],
      ["Yugoslavia","Yugoslavia"],
      ["Zambia", "Zambia"],
      ["Zambia","Zambia"],
      ["Zimbabwe","Zimbabwe"]
    ]
    if selected_country == ""
      countries.unshift(["-Country-",""])
      selected_country = "-Country-"
    end
    select_tag(name, options_for_select(countries, selected_country), options)
  end

  def select_gender(name, selected_gender = nil, options = {})
    gender = []
    gender << ["-Gender-",""] if selected_gender == "" or selected_gender.nil?
    gender << ["Male", "Male"] << ["Female", "Female"]
    select_tag(name, options_for_select(gender, selected_gender), options)
  end

  def get_contest_categories_list(contest_id = nil, selected_category = nil)
    contest_categories = Users::Votigo.get_contest_categories({:contest_id => contest_id})
    categories = []
    if contest_categories["status"].nil?
      contest_categories["Categories"].each do |cat|
        categories << [cat["Category"]["name"].split('_').map {|w| w.capitalize }.join(' '), cat["Category"]["name"]]
      end
    end
    categories.unshift(["-Category-",""]) if selected_category == "" or selected_category.nil?
    categories
  end

  def select_image_category(name, selected_category = nil, options = {})
    categories = []
    categories << ["-Category-",""] if selected_category == "" or selected_category.nil?
    categories = get_contest_categories_list(@contest_id, selected_category)
    select_tag(name, options_for_select(categories, selected_category), options)
  end

end