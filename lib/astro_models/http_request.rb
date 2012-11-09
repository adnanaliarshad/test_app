module AstroModels::HttpRequest

  def http_build_url(options)
    request = options[:prefix]
    # :dont_remove_trailing_slash is added especially for some RSS feeds (like hollywoodlife),
    # which separate URLs like blabla.com/blabla and blabla.com/blabla/
    request.gsub!(/\/$/, '') unless options[:dont_remove_trailing_slash]
    if options[:params]
      request += "?" unless request =~ /\?$/
      request += if options[:params].is_a?(Hash)
        options[:params].to_query
      else
        options[:params]
      end
    end
    request
  end

  def http_request_xml(options = {})
    result = http_request(options)
    Nokogiri::XML(result.body)
  end

  def http_request_json(options = {})
    result = http_request(options)
    ActiveSupport::JSON.decode(result.body)
  end

  def http_request(options = {})
    init_options(options) 
    request = http_build_url(options)
    http = init_http(options, request)
    result = nil
    ms = Benchmark.ms do 
      result = http.send(options[:method], request, options[:headers])
    end
    http_request_logger.info "--> %d %s (%d %.0fms)" % [result.code, result.message, result.body ? result.body.length : 0, ms] if http_request_logger
    result

  end

  def http_post_request(params = {}, options = {})
    options = init_options(options.merge(:method => "post"))
    request = options[:prefix]
    http = init_http(options, request)
    result = nil
    ms = Benchmark.ms { result = http.send(options[:method], request, (params.is_a?(Hash) ? params.to_query : params)) }
    http_request_logger.info "--> %d %s (%d %.0fms)" % [result.code, result.message, result.body ? result.body.length : 0, ms] if http_request_logger
    result
  end

  
  private

    def init_options(options = {})
      options[:method] ||= "get"
      options[:headers] ||= {}
      options[:prefix] ||= self.is_a?(Class) ? self.prefix : self.class.prefix
      options[:site] ||= self.site
      options
    end

    def init_http(options, request)
      parsed_site = URI.parse(options[:site])
      http_request_logger.info("#{options[:method].upcase} #{parsed_site.scheme}://#{parsed_site.host}:#{parsed_site.port}#{request}") if http_request_logger
      http = Net::HTTP.new(parsed_site.host, parsed_site.port)
      http.use_ssl = (parsed_site.scheme == 'https')
      # Timeout is set in seconds
      http.open_timeout = options[:open_timeout] || 200
      http.read_timeout = options[:read_timeout] || 1000
      http
    end

    def http_request_logger
      unless instance_variable_defined?("@http_request_logger")
        @http_request_logger = Rails.logger
      end
      @http_request_logger
    end

end
