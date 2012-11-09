module AstroModels::Users::Validation


  def validate_birthplace?(prefix,number)
    birthplace_fields = [ "#{prefix}_country_#{number}", "#{prefix}_state_#{number}", "#{prefix}_city_#{number}" ]
    changed_birthplace_fields = self.changed & birthplace_fields

    condition = @methods_for_validation.include?("#{prefix}_country_#{number}")
    condition &&= !(!self.send("#{prefix}_place_id_#{number}").blank? && changed_birthplace_fields.empty?)
    condition ||= [ "#{prefix}_tzdir_#{number}", "#{prefix}_tzminute_#{number}", "#{prefix}_dst_#{number}" ].any? do |field|
      !self.send(field)
    end
    condition
  end


  private

    NOT_NULL = %w{ name_1 name_2 birth_country_1 birth_country_2 birth_city_1 birth_city_2 residence_country email }
    NOT_NULL_BIRTH_DATE = %w{ birth_date_1 birth_date_2 }
    NOT_NULL_BIRTH_TIME = %w{ birth_time_1 birth_time_2 }
    NOT_NULL_IF_US_1 = %w{ birth_state_1 zip }
    NOT_NULL_IF_US_2 = %w{ birth_state_2 }

    MESSAGES = {
      :not_empty => "should not be empty",
      :correct_date => "should be correct date",
      :correct_time => "should be correct time",
      :cant_find_place => "Please select another city/country, nearest to your city",
      :multiple_places => 
        "Multiple locations match what you entered. Please select one or enter a more exact city name.",
      :server_error => "There was some server error while checking your birthplace"
    }

    def validate
      NOT_NULL.each do |method|
        add_error(method, MESSAGES[:not_empty]) if send(method).blank? && @methods_for_validation.include?(method)
      end
      NOT_NULL_BIRTH_DATE.each do |method|
        add_error(method, MESSAGES[:correct_date]) if send(method).blank? && @methods_for_validation.include?(method)
      end
      NOT_NULL_BIRTH_TIME.each do |method|
        add_error(method, MESSAGES[:correct_time]) if send(method).blank? && @methods_for_validation.include?(method)
      end
      NOT_NULL_IF_US_1.each do |method|
        error_condition = send(method).blank? && @methods_for_validation.include?(method) && birth_country_1 == 'US'
        add_error(method, MESSAGES[:not_empty]) if error_condition
      end
      NOT_NULL_IF_US_2.each do |method|
        error_condition = send(method).blank? && @methods_for_validation.include?(method) && birth_country_2 == 'US'
        add_error(method, MESSAGES[:not_empty]) if error_condition
      end
      validate_correct_place('birth',1) if validate_birthplace?('birth',1)
      validate_correct_place('birth',2) if validate_birthplace?('birth',2)
      validate_correct_place('relocation',0) if validate_birthplace?('relocation',0)
      @errors.empty?
    end


    def add_error(method, description)
      @errors ||= HashWithIndifferentAccess.new
      field = validation_field_name(method)
      @errors[field] ||= []
      @errors[field] << description
    end


   # def validate_correct_place(number)
   #   begin
   #     return if instance_variable_get("@accurate_place_#{number}_set")
   #     country = send("birth_country_#{number}")
   #     state = send("birth_state_#{number}")
   #     city = send("birth_city_#{number}")
   #     birthdate = send("birth_date_#{number}")
   #     condition = !country.blank? && !city.blank?
   #     condition &&= !state.blank? if country == "US"
   #     if condition
   #       data, status = Atlas.get_birthplace(country, state, city, birthdate)
   #       if data.blank?
   #         add_error("birth_city_#{number}", MESSAGES[:cant_find_place])
   #       elsif data.size > 1
   #         instance_variable_set("@multiple_locations_#{number}", get_multiple_locations_list(data))
   #         add_error("birth_city_#{number}", MESSAGES[:multiple_places])
   #       else
   #         set_place(number, data.first)
   #       end
   #     end
   #   rescue => error
   #     add_error("birth_city_#{number}", MESSAGES[:server_error])
   #   end
   # end

  def validate_correct_place(prefix,number)
      begin
        return if instance_variable_get("@accurate_#{prefix}_place_#{number}_set")
        country = send("#{prefix}_country_#{number}")
        state = send("#{prefix}_state_#{number}")
        city = send("#{prefix}_city_#{number}")
        birthdate = number < 1 ? send("birth_date_1") : send("#{prefix}_date_#{number}")
        condition = !country.blank? && !city.blank?
        condition &&= !state.blank? if country == "US"
        if condition
          data, status = Atlas.get_birthplace(country, state, city, birthdate)
          if data.blank?
            add_error("#{prefix}_city_#{number}", MESSAGES[:cant_find_place])
          elsif data.size > 1
            instance_variable_set("@multiple_#{prefix}_locations_#{number}", get_multiple_locations_list(data))
            add_error("#{prefix}_city_#{number}", MESSAGES[:multiple_places])
          else
            set_place(prefix,number, data.first)
          end
        end
      rescue => error
        add_error("#{prefix}_city_#{number}", MESSAGES[:server_error])
      end
    end

    # Returns correct name of validated field. If we validate params of only one person, we should
    # just show humanized field name, e.g. "Email". If we validate params of couple, we need to add number of person
    # to field name, e.g. "Person 1 Name" or "Person 2 City". Keys are usually looks like "name1", "city2", etc.
    def validation_field_name(key)
      humanized_key = if key =~ /birth_date/
        "Birth date"
      elsif key =~ /time/
        "Birth time"
      elsif key =~ /reloc/
        "Relocation city"
      end
      if number_match = key.match(/(\d+)/)
        humanized_key ||= key.gsub(/_\d+/, '').humanize
        number = number_match[1].to_i
        if number == 2
          "Person 2 #{humanized_key}"
        elsif number == 1 && @methods_for_validation.any? { |m| m.include?("2") }
          "Person 1 #{humanized_key}"
        else
          humanized_key
        end
      else
        humanized_key ||= key.humanize
      end
    end


    def get_multiple_locations_list(data)
      locations = {}
      data.each_with_index do |place, index|
        text = place[:city]
        text += " (#{place[:county]})" unless place[:county].blank?
        text += ", #{place[:state]}" unless place[:state].blank?
        text += ", #{place[:country]}"
        locations[text] = [ 
          place[:city], 
          place[:place_id], 
          place[:state], 
          place[:county], 
          place[:country], 
          place[:latitude_str], 
          place[:longitude_str], 
          place[:latitude_dec], 
          place[:longitude_dec], 
          place[:tzhour],
          place[:tzminute],
          place[:tzdir],
          place[:dst]
        ].join(";")
        break if index > 3
      end
      locations
    end


    def set_place(prefix,number, place)
      [ @session, @database ].each do |engine|
        if engine
          engine.send("#{prefix}_city_#{number}=", place[:city])
          engine.send("#{prefix}_place_id_#{number}=", place[:place_id])
          engine.send("#{prefix}_county_#{number}=", place[:county])
          engine.send("#{prefix}_state_#{number}=", place[:state])
          engine.send("#{prefix}_country_#{number}=", place[:country])
          engine.send("#{prefix}_latitude_str_#{number}=", place[:latitude_str])
          engine.send("#{prefix}_longitude_str_#{number}=", place[:longitude_str])
          engine.send("#{prefix}_latitude_dec_#{number}=", place[:latitude_dec])
          engine.send("#{prefix}_longitude_dec_#{number}=", place[:longitude_dec])
          engine.send("#{prefix}_timezone_#{number}=", place[:tzhour])
          engine.send("#{prefix}_tzminute_#{number}=", place[:tzminute])
          engine.send("#{prefix}_tzdir_#{number}=", place[:tzdir])
          engine.send("#{prefix}_dst_#{number}=", place[:dst])
        end
      end
      instance_variable_set("@accurate_#{prefix}_place_#{number}_set", true)
    end

end
