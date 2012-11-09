class Users::Arwen


  module Errors
    class WrongEmail < StandardError; end
    class WrongPassword < StandardError; end
    class WrongUuid < StandardError; end
    class WrongSite < StandardError; end
    class DuplicatedEmail < StandardError; end
    class DuplicatedNick < StandardError; end
    class ConnectionError < StandardError; end
    class ExistedNick < StandardError; end
    class UnknownStatus < StandardError; end
  end

  SITE = "ivillage"
  attr_reader :uuid, :email, :nick, :zip, :country, :birthdate, :gender, :last_name, :first_name

  def initialize(options = {})
    @uuid = options["uuid"] unless options["uuid"].to_s == ""
    @email = options["email"] unless options["email"].to_s == ""
    @nick = options["nick"] unless options["nick"].to_s == ""
    @last_name = options["last_name"] unless options["last_name"].to_s == ""
    @first_name = options["first_name"] unless options["first_name"].to_s == ""
    @birthdate = options["birthdate"] unless options["birthdate"].to_s == ""
    @gender = options["gender"] unless options["gender"].to_s == ""
  end


  class << self

    def create_from_xml(xml)
      new(
        "uuid" => xml.xpath("./id").inner_text,
        "email" => xml.xpath("./primary_email").inner_text,
        "nick" => xml.xpath("./username").inner_text,
        "birthdate" => xml.xpath("./birthdate").inner_text,
        "gender" => xml.xpath("./gender").inner_text,
        "first_name" => xml.xpath("./first_name").inner_text,
        "last_name" => xml.xpath("./last_name").inner_text
      )
    end

    def login(options)
      persons_with_given_email_xml = get_person_data("email" => options["email"], "site" => SITE)
      raise Errors::WrongEmail if persons_with_given_email_xml.empty?
      matched_person_xml = persons_with_given_email_xml.find do |person|
        result = http_post_request("/api/login", "login", {
          "context" => get_context_from_site(SITE),
          "password" => options["password"],
          "username" => person.xpath("./username").inner_text
        })
        result =~ /\/api\/persons\/\d+/
      end
      raise Errors::WrongPassword unless matched_person_xml
      create_from_xml(matched_person_xml)
    end


    def create_user(options)
      result = http_post_request("/api/persons", "person", {
        "username" => options["username"],
        "primary_email" => options["email"],
        "context" => 6,
        "password" => options["password"],
        "birthdate" => options["dob"],
        "gender" => options["gender"],
        "last_name" => options["last_name"],
        "first_name" => options["first_name"]
      })
      if match = result.match(/\/api\/persons\/(\d+)/)
        match[1]
      elsif result =~ /Username is not unique/
        raise Errors::DuplicatedNick
      elsif result =~ /primary_email \(unique,unique\)/
        raise Errors::DuplicatedEmail
      end
    end


    def update_user(options)
      #raise User::Error::WrongUuid unless existed_uuid?(options)
      #raise User::Error::DuplicatedNick if duplicated_nick_while_updating?(response_xml)
      #raise User::Error::DuplicatedEmail if duplicated_email_while_updating?(response_xml)
      url = generate_find_by_uuid_url(options["uuid"])
      params = {}
      params["birthdate"] = options["birthdate"] unless options["birthdate"].blank?
      params["gender"] = options["gender"] unless options["gender"].blank?
      params["last_name"] = options["last_name"] unless options["last_name"].blank?
      params["first_name"] = options["first_name"] unless options["first_name"].blank?
      result = http_put_request(url, "person", params)
      result
    end


    def delete_user(options)
      url = generate_find_by_uuid_url(options["uuid"])
      result = http_delete_request(url)
      result =~ /persons type="array">1<\/persons/
    end


    def get_person_data(options)
      result = if options["uuid"].to_s != ""
        url = generate_find_by_uuid_url(options["uuid"])
        http_get_request(url)
      elsif options["email"].to_s != ""
        url = generate_find_by_email_url(options["email"], SITE)
        http_get_request(url)
      elsif options["nick"].to_s != ""
        url = generate_find_by_nick_url(options["nick"], SITE)
        http_get_request(url)
      end
      Nokogiri::XML(result).xpath("//person[//id]")
    end

    def get_person_info(options, type = "id")
      result = if options["uuid"].to_s != ""
       url = generate_find_by_uuid_url(options["uuid"])
       http_get_request(url)
     elsif options["email"].to_s != ""
       url = generate_find_by_email_url(options["email"], SITE)
       http_get_request(url)
     elsif options["nick"].to_s != ""
       url = generate_find_by_nick_url(options["nick"], SITE)
       http_get_request(url)
     end
      Nokogiri::XML(result).xpath("//person[//id]//#{type}").inner_text
    end

    def existed_email_status(options)
      if options["uuid"].to_s != ""
        person_xml = get_person_data("uuid" => options["uuid"], "site" => SITE)
        if !person_xml.empty?
          return false if person_xml.xpath("//primary_email").any? { |t| t.text == options["email"] }
        end
      end
      get_person_data("email" => options["email"], "site" => SITE).empty? ? "false" : "true"
    end


    def existed_email?(options)
      existed_email_status(options) == 'true'
    end


    def existed_nick?(options)
      if options["uuid"].to_s != ""
        person_xml = get_person_data("uuid" => options["uuid"], "site" => SITE)
        if person_xml
          nick = person_xml.xpath("//username").inner_text
          return false if options["nick"] == nick
        end
      end
      !get_person_data("nick" => options["nick"], "site" => SITE).empty?
    end


    def existed_uuid?(options)
      !get_person_data("uuid" => options["uuid"], "site" => SITE).empty?
    end


    def find_user(options)
      result = get_person_data("uuid" => options["uuid"], "site" => SITE, "email" => options["email"], "nick" => options["username"])
      create_from_xml(result)
    end

    def get_context_from_site(site)
      case site
        when 'astrology'; 6
        when 'ivillage'; 0
        else; raise Errors::WrongSite
      end
    end

    def get_all_newsletters
      url = generate_find_all_newsletters_url
      response = http_get_request(url)
      newsletters = Array.new
      Nokogiri::XML(response).xpath("//newsletters//newsletter")
      noko_response =Nokogiri::XML(response).xpath("//newsletters/newsletter")
      noko_response.each do |newsletter|
        newsletters << {:id => newsletter.xpath("id").inner_text , :name => newsletter.xpath("name").inner_text,
                        :description => newsletter.xpath("description").inner_text }
      end
      newsletters
    end

    def newsletters_subscription(options)
      url = generate_newsletters_subscription_url
      response = http_post_request(url, "bulk-newsletter-subscription", options)
      subscriptions = Array.new
      Nokogiri::XML(response).xpath("//newsletter_subscription").each do |newsletter|
        subscriptions << {:subscription_id => newsletter.xpath("subscription_id").inner_text , :newsletter_id => newsletter.xpath("newsletter_id").inner_text,
                        :person_id => newsletter.xpath("person_id").inner_text }
      end
      subscriptions
    end

    def newsletters_unsubscribe(newsletter_id)
      url = "/api/newsletter-subscriptions/#{newsletter_id}"
      http_delete_request(url)
    end

    def subscribers_to_newsletter(newsletter_id ,person_id)
      url = "/api/newsletter-subscriptions?newsletter_id=#{newsletter_id}&person_id=#{person_id}"
      response = http_get_request(url)
      subscribers = []
      Nokogiri::XML(response).xpath("//newsletter_subscription/person_id").each do |subscriber|
        subscribers << subscriber.inner_text.split('persons/')[1]
      end
      subscribers
    end

    def subscriptions_to_newsletter(newsletter_id ,person_id)
      url = "/api/newsletter-subscriptions?newsletter_id=#{newsletter_id}&person_id=#{person_id}"
      response = http_get_request(url)
      subscribers = []
      Nokogiri::XML(response).xpath("//newsletter_subscription/id").each do |subscriber|
        subscribers << subscriber.inner_text
      end
      subscribers
    end

    private

      def generate_find_by_email_url(email, site)
        "/api/persons?" + get_params({:email => email, :context => get_context_from_site(site)})
      end

      def generate_find_by_nick_url(nick, site)
        "/api/persons?" + get_params({:username => nick, :context => get_context_from_site(site) })
      end

      def generate_find_by_uuid_url(person_id)
        "/api/persons/#{person_id}"
      end

      def generate_find_all_newsletters_url
        "/api/newsletters"
      end

      def generate_newsletters_subscription_url
        "/api/bulk-newsletter-subscriptions"
      end



      def http_get_request(url)
        request = Net::HTTP::Get.new(url.to_s)
        request.basic_auth(User.arwen_user, User.arwen_password)
        http_request('get', request, url)
      end


      def http_post_request(url, type, params)
        request = Net::HTTP::Post.new(url.to_s)
        request.basic_auth(User.arwen_user, User.arwen_password)
        unless type == "bulk-newsletter-subscription"
          request.body = get_xml_from_params(type, params)        
        else
          request.body = get_xml_from_recursive_params(type, params)
        end
        http_request('post', request, url, params)
      end


      def http_put_request(url, type, params)
        request = Net::HTTP::Put.new(url.to_s)
        request.basic_auth(User.arwen_user, User.arwen_password)
        request.body = get_xml_from_params(type, params)
        http_request('put', request, url, params)
      end


      def http_delete_request(url)
        request = Net::HTTP::Delete.new(url.to_s)
        request.basic_auth(User.arwen_user, User.arwen_password)
        http_request('delete', request, url)
      end


      def http_request(request_type, request, url, params = nil)
        http_request_logger.info("Making #{request_type.upcase} request to: #{url}#{", with params: #{params}" if params}")
        result = ""
        ms = Benchmark.realtime do
          http = Net::HTTP.new(User.arwen_host).start
          result = http.request(request)
          http.finish
        end * 1000.0
        http_request_logger.info("Time: %.0fms" % [ ms ])
        http_request_logger.info("Status - #{result.code}, response is: #{result.body}")
        result.body
      rescue Errno::ECONNREFUSED => error
        http_request_logger.error("Can't connect to Arwen server, error: #{error.class}, #{error.message}")
        raise User::Error::ConnectionError
      end

       def parse_recursive_params(xml,params)
         params.each do |key, value|
          if value.class ==  Hash
            xml.send("newsletter_subscription") do
              parse_recursive_params(xml, value)
            end
          else
            xml.send(key + "_", value)
          end

         end
       end

      def get_xml_from_recursive_params(type, params)
        Nokogiri::XML::Builder.new do |xml|
            xml.send(type) do
              parse_recursive_params(xml, params)
          end
        end.to_xml
      end

      def get_xml_from_params(type, params)
        Nokogiri::XML::Builder.new do |xml|
          xml.send(type + "s") do
            xml.send(type) do
              params.each do |key, value|
                xml.send(key + "_", value)
              end
            end
          end
        end.to_xml
      end

    def http_request_logger
      unless instance_variable_defined?("@http_request_logger")
        @http_request_logger = Rails.logger
      end
      @http_request_logger
    end

    def get_params(params = {})
      hash = generate_hash(params)
      params.to_query + (!params.empty? ? "&" : "") + "hash=#{hash}"
    end

    def generate_hash(params = {})
      opts_string = params.map {|k,v| "#{k}=#{v}"}.sort.join("&")
      Digest::SHA1.hexdigest(opts_string + Time.now.strftime("%Y%m%d"))
    end

  end

end
