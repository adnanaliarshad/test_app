# This class implements writing and reading data to and from cache with tags support.
# For all actions related to cache in Astrology.com, please use this class.
#
# In Astrology.com, we can't clear all cache, because it will just kill all our app servers 
# under load. So, we need some mechanism for clearing e.g. top block on the homepage, 
# or all blocks on the homepage, etc. For this, we use tags conception.
#
# A tag is actually some name and number. E.g. 'home' -> '25'. To clear cache associated 
# with tag, we just need to increase the number. We store these tags in memcached too.
# When we store some data in cache, we will store the data and the tags, e.g.:
# {
#   :data => 'blablabla',
#   :tags => { "home" => 25, "drupal" => 17 }
# }
# When we retrieve the cache with data, we will check version of tags by retrieving 
# them from memcached. If version of tag in memcached == version of tag in cached 
# data - we will use cached data. Otherwise - we will clear the cache and generate it again.
#  
# This way, e.g. the top part of the homepage (wheel, horoscope and mood meter) will have tags 
# [ 'home', 'metis', 'home_top' ]. If we want to clear e.g. all cache on the homepage, we will 
# increase number of 'home' tag.
class AstroCache

  # It can be set by cached content if such content should not be cached
  cattr_accessor :do_not_cache_block

  # Please don't use AstroCache methods directly, but include this Interface module to
  # your class instead, and use astro_cache method in your class
  module Interface
    def astro_cache(key, options = {}, &block)
      astro_cache_instance.cache(key, options, &block)
    end

    # Sort of Factory
    def astro_cache_instance
      if self.is_a?(ActionView::Base)
        AstroCache::View.new(self, @current_user)
      else
        AstroCache::Simple.new(self, @current_user)
      end
    end
  end


  # Read cached data from cache. If it is not possible, it will generate data by executing &block
  # and write it and its tags to cache. Options are just usual options for Rails.cache (like
  # :expires_in), with some additional options:
  # Additional options:
  #   * :tags - array of tags associated with current cache. By clearing these tags you will
  #             be able to clear this cache
  #   * :set_datetime - select personalized date or time of @current_user in user[birth_date] 
  #                     or user[birth_time] select boxes after reading cache
  #   * :set_scope_slider - set checkboxes in b-scopes-slider according to @current_user.horoscopes 
  #                         value after reading cache
  #   * :set_wheel - set correct date in a b-wheel block
  #   * :set_hero - set correct date in b-hero blocks (e.g. on divination pages)
  #   * :set_popup - set correct date in the text of b-popup-birthdate-changer blocks
  def cache(key, options = {}, &block)
    name = cache_name(key)
    tags = options.delete(:tags) || []
    check_tags_existance(name, tags)
    if ActionController::Base.perform_caching
      cache = read(name, options)
      if cache && cache.is_a?(Hash) && cache[:data] && is_cache_actual?(cache) 
        # Overwriting the cache with the same data for avoiding its expiration
        # when 'freeze cache' option is enabled.
        write(name, cache, options) if AstroConfig.freeze_cache?
        data = modify_cache_by_personalized_data(cache[:data], options)
        data.is_a?(String) ? data.html_safe : data
      else
        self.class.do_not_cache_block = false
        output = execute_block(&block)
        unless self.class.do_not_cache_block
          tags_hash = generate_tags_hash(tags)
          write(name, { :data => output, :tags => tags_hash }, options)
        end
        self.class.do_not_cache_block = false
        output.is_a?(String) ? output.html_safe : output
      end
    else
      execute_block(&block)
    end
  end


  # Clears cache associated with given tag by increasing tag's value
  def clear_by_tag(tag)
    value = read(tag)
    write(tag, Time.new.to_i)
  end


  # Clears cache associated with given key by just deleting cache with give key
  def clear_by_key(key)
    delete(key)
  end


  private

    def initialize(context, current_user)
      @context = context
      @current_user = current_user
    end

    def cache_name(key)
      host = @context.respond_to?(:request) ? @context.request.host : ''
      "#{CACHE_CONFIG['version']}_#{host}_#{key}"
    end

    def read(name, options = {})
      Rails.cache.read(name, options)
    end

    def write(name, output, options = {})
      Rails.cache.write(name, output, options)
    end

    def delete(name)
      Rails.cache.delete(name)
    end

    def check_tags_existance(name, tags)
      tags.each do |tag|
        unless all_cache_tags.include?(tag)
          raise "You use unexisted tag #{tag} in #{name} cache. Please add this tag to config/cache.yml"
        end
      end
    end

    def all_cache_tags
      @all_cache_tags ||= CACHE_CONFIG['tags'].values.flatten.map { |tag| tag['name'] }
    end

    def is_cache_actual?(cache)
      (cache[:tags] || {}).all? do |key, value|
        read(key) == value
      end
    end

    def generate_tags_hash(tags)
      tags.inject({}) do |hash, tag|
        value = read(tag)
        if value.blank?
          value = Time.new.to_i
          write(tag, value)
        end
        hash[tag] = value
        hash
      end
    end

    def modify_cache_by_personalized_data(data, options = {})
      data = set_personalized_birth_datetime_options(data) if options.delete(:set_datetime)
      data = check_selected_horoscopes_for_scopes_slider(data) if options.delete(:set_scopes_slider)
      data = set_birthdate_in_wheel(data) if options.delete(:set_wheel)
      data = set_birthdate_in_popup(data) if options.delete(:set_popup)
      data = set_birthdate_in_hero(data) if options.delete(:set_hero)
      data = set_ord_in_mps(data, options.delete(:update_mps_ord)) if options[:update_mps_ord]
      data = set_match_com(data) if options[:set_match_com]
      data
    end

    def set_personalized_birth_datetime_options(raw_result)
      result = raw_result.gsub(/ selected="selected"/, '') 
      doc = Nokogiri::HTML(result)
      date = @current_user.personalized_date
      select_given_date(doc, date)
      doc.css('body > *').to_html
    end

    def check_selected_horoscopes_for_scopes_slider(result)
      unless @current_user.horoscopes.blank?
        result.gsub!(/<input([^>]+)(checked="checked")/, '<input\1')
        @current_user.horoscopes.each do |content_type_id|
          result.gsub!(/<input([^>]+)(id="selected_horoscope_#{content_type_id}")/, '<input\1\2 checked="checked"')
        end
      end
      result
    end

    def set_birthdate_in_wheel(data)
      month = AppConfig['short_months'][@current_user.personalized_date.month.to_i - 1]
      day = @current_user.personalized_date.day
      year = @current_user.personalized_date.year
      data.gsub!(/(b-wheel_date_month['"][^>]*>)([^<]*)</, '\1' + month + '<')
      data.gsub!(/(b-wheel_date_day['"][^>]*>)([^<]*)</, '\1' + day.to_s + '<')
      data.gsub!(/(b-wheel_date_year['"][^>]*>)([^<]*)</, '\1' + year.to_s + '<')
      data
    end

    def set_birthdate_in_popup(data)
      date = "#{AppConfig['short_months'][@current_user.personalized_date.month.to_i - 1]}. #{@current_user.personalized_date.day}"
      data.gsub(/(b-popup-birthdate-changer_month-day['"][^>]*>)([^<]*)</, '\1' + date + '<')
    end

    def set_birthdate_in_hero(data)
      data.gsub(/(b-hero_birthdate_your['"][^>]*>)([^<]*)</, '\1' + @current_user.personalized_date.strftime("%B %d, %Y") + '<')
    end

    def set_ord_in_mps(data, ord)
      ord = Kernel.rand(10000000000) unless ord.is_a?(Integer)
      data.ads.each { |name, ad| ad.gsub!(/ord=\d+/, "ord=#{ord}") }
      data
    end

    def set_match_com(data)
      doc = Nokogiri::HTML(data)
      who = MatchCom.who_default_option(@current_user)
      doc.css("form select[@name='who'] option[@selected='selected']").each do |option|
        option.remove_attribute("selected")
      end
      doc.css("form select[@name='who'] option[@value='#{who}']").each do |option| 
        option.set_attribute("selected", "selected") 
      end
      doc.css("form input#user_zip").first.set_attribute("value", @current_user.zip.to_s)
      doc = select_given_date(doc, @current_user.personalized_date)
      doc.css('body > *').to_html
    end


    def select_given_date(doc, date)
      doc.css("form select[@name='user[birth_date_1(2i)]'] option[@selected='selected']").each do |option|
        option.remove_attribute("selected")
      end
      doc.css("form select[@name='user[birth_date_1(2i)]'] option[@value='#{date.month}']").each do |option| 
        option.set_attribute("selected", "selected") 
      end
      doc.css("form select[@name='user[birth_date_1(3i)]'] option[@selected='selected']").each do |option|
        option.remove_attribute("selected")
      end
      doc.css("form select[@name='user[birth_date_1(3i)]'] option[@value='#{date.day}']").each do |option| 
        option.set_attribute("selected", "selected")
      end
      doc.css("form select[@name='user[birth_date_1(1i)]'] option[@selected='selected']").each do |option|
        option.remove_attribute("selected")
      end
      doc.css("form select[@name='user[birth_date_1(1i)]'] option[@value='#{@current_user.is_birthdate_set? ? date.year : 1980}']").each do |option| 
        option.set_attribute("selected", "selected")
      end
      doc
    end
      
    class View < AstroCache

      private

        def put(data)
          data
        end

        def execute_block(&block)
          @context.capture(&block)
        end

    end


    class Simple < AstroCache

      private

        def put(data)
          data
        end

        def execute_block(&block)
          block.call
        end

    end


end
