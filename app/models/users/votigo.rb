require 'rest-client'
require 'astro_cache'

class Users::Votigo

  attr_accessor :signature, :session_id
  extend AstroModels::HttpRequest
  extend AstroModels::AstroErrorReporter
  extend AstroCache::Interface
  attr_accessor :country, :postal_code, :session_id, :other_url, :language, :id, :email, :username

  @@signature = ""
  @@contest = ""
  @@scount = 0
  @@serror = nil

  module Errors
    class WrongPassword < StandardError; end
    class DuplicatedNick < StandardError; end
    class DuplicatedEmail < StandardError; end
  end

  def initialize(options = {})
    @country = options["country"] unless options["country"].blank?
    @postal_code = options["postal_code"] unless options["postal_code"].blank?
    @session_id = options["session_id"] unless options["session_id"].blank?
    @other_url = options["other_url"] unless options["other_url"].blank?
    @language = options["language"] unless options["language"].blank?
    @id = options["id"] unless options["id"].blank?
    @username = options["username"] unless options["username"].blank?
    @email = options["email"] unless options["email"].blank?
  end

  # This method is used to create a new user in the system if user is created successfully status
  # with 1 and user object is returned otherwise status with 0 and error message is returned.
  # And a hash with keys username, password, email must be provided. However extra parameters
  # may be provided for more parameters information visit :
  # http://smbaqa05code.votigo.com/doc/add
  def self.create(options, signature)
    params = {:signature => signature }.merge(options)
    prefix = "/users/add.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    user = JSON.parse(result.body)
    if user['status'] == 1
      user
    elsif user['status'] == 0
      raise Errors::DuplicatedNick
    end
  end

  def self.update(options)
    params = {:signature => @@signature}.merge(options)
    prefix = "/users/edit.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
      user = JSON.parse(result.body)
      if user['status'] == 1
        user
      end
    else
      @@signature = get_signature
      self.update(options)
    end
  end

  # This method is used to create a new user in the system if user is created successfully status
  # with 1 and user object is returned otherwise status with 0 and error message is returned.
  # And a hash with keys social_id, and username must be provided. However extra parameters
  # may be provided for more parameters information visit :
  # http://smbaqa05code.votigo.com/doc/addSocialUser
  def self.social_create(options)
    params = {:signature => @@signature}.merge(options)
    prefix = "/users/addSocialUser.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
      user = JSON.parse(result.body)
      if user['status'] == 1
        user
      elsif user['status'] == 0
        raise Errors::DuplicatedNick
      end
    else
      @@signature = get_signature
      self.social_create(options)
    end
  end

  def self.user_valid?(options)
    # this function receives email address to check whether it is available or not
    # and returns true or false.
    params = {:signature => @@signature}.merge(options)
    prefix = "/users/getUserIdByEmail.json"
    email = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.user_valid?(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    if !!email == email || email.nil?
      true
    else
      email["status"].nil? ? true : false
    end
  end

  def self.get_user_id_by_email(options, signature)
    # this function receives email address to check whether it is available or not
    # and returns true or false.
    params = {:signature => signature }.merge(options)
    prefix = "/users/getUserIdByEmail.json"
    response = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    response["status"].nil? ? response['User']['id']: nil
  end

  def self.can_do_entry_submission?(options, contest=nil)
    # this function receives user's email id to check whether this user has submitted an
    # entry or not and returns true or false.
    params = {:signature => @@signature }.merge(options)
    prefix = "/users/getUserEntriesByUserEmailId.json"
    response = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.can_do_entry_submission?(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    unless response == true
      unless response["status"].nil?
        submission = true
      else
        submission = response["Entries"].count>0 ? false : true
        if response["Entries"].count>0
          submission = true
          response["Entries"].each do |entry|
            if entry['Entry']["contest_id"].to_i == contest.to_i
              submission = false
            end
          end
        end
      end
    else
      submission = true
    end
    submission
  end

  def self.login(options, signature)
    # To login a hash containing keys email and password must be provided if user
    # logs in successfully user object is returned otherwise a hash with status 0.
    params = {:signature => signature }.merge(options)
    prefix = "/users/login.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    result = JSON.parse(result.body)
    if result['status'] == 0
      raise Errors::WrongPassword
    else
      result
    end
  end

  # This function is sued to change password. A hash containing keys :email,:password, :new_password,
  # user_id, and session_id must be provided. If password is changed this function will return
  # user object(with id, new_password, and session_expires attributes) and nil otherwise.
  def self.change_password(options, signature)
    params = {:signature => signature}.merge(options)
    prefix = "/users/changePassword.json"
    user = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    user["User"]
  end

  # This method is used to login a user in the system if user is logged in successfully then
  # user object is returned otherwise status with 0 and error message is returned.
  # And a hash with keys social_id must be provided.
  def self.social_login(options)
    params = {:signature => get_signature}.merge(options)
    prefix = "/users/loginSocialUser.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    #unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
      response = self.succefull_response(result)
    #else
    #  @@signature = get_signature
    #  response = self.social_login(options)
    #end
    unless response['User'].nil?
      new(response['User'])
    else
      nil
    end
  end

  def self.social_user_valid?(options, signature)
    # this function receives social id to check whether it is available or not
    # and returns true or false.
    params = {:signature => signature }.merge(options)
    prefix = "/users/getUserBySocialId.json"
    user = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    user["status"].nil? ? false : true
  end

  def self.logout(options)
    params = {:signature => @@signature, :user_id => options[:user_id], :session_id => options[:session_id]}
    prefix = "/users/logout.json"
    user = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.logout(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    user
  end

  # To upload picture as entry in a contest a hash with keys contest_id, session_id, user_id,
  # entryname, description, filecontents(if local image is too upload) and fileurl(for web url
  #  of image) must be provided. Extra parameters may be provided by user to see complete guide
  # visit : http://smbaqa05code.votigo.com/doc/uploadPhoto

  def self.upload_profile_pic(options)
    params ={ :signature => @@signature }.merge(options)
    prefix = "/entries/uploadPhoto.json"
    response = begin
      result = self.restclient_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature"
        JSON.parse(result.body)
      else
        @@signature = get_signature
        self.upload_profile_pic(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    response
  end

  def self.get_all_contests(options = {}, signature)
    params = {:signature => signature}.merge(options)
    prefix = "/contests/allContests.json"
    contests = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    contests
  end

  def self.get_contest_categories(options = {})
    params = {:signature => @@signature}.merge(options)
    prefix = "/contests/getAllCategories.json"
    contests = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.get_contest_categories(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
      error_report(:class_name => self.to_s, :exception => error)
    end
    contests
  end

  def self.get_contest_by_id(options = {})
    if @@contest == ""
      @@signature = get_signature if @@signature == ""
      params = {:signature => @@signature}.merge(options)
      prefix = "/contests/getContestById.json"
      @@contest = begin
        result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
        unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
          self.succefull_response(result)
        else
          @@signature = get_signature
          self.get_contest_by_id(options)
        end
      rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
      end
    end
    @@contest
  end

  # if provided without params, returns all entries.
  # User may provide other options in hash. like contest_id to get all entries of a hash.
  # limit can be provided to get limited no of records. By default it is 5.
  # For more information visit : http://smbaqa05code.votigo.com/doc/getAllEntries
  def self.get_all_entries(options = {}, page_no = 1, sort = "created", direction = "asc")
    tags = %w{votigo slides slides-gallery}
    cache_name = "slides_gallery_photo_#{page_no}_#{sort}_#{direction}_#{options.values.join('_')}"
    astro_cache(cache_name, :tags => tags, :expires_in => 5.minutes) do
      options.delete(:category) if options[:category] and options[:category] == ""
      params = {:signature => @@signature}.merge(options)
      prefix = "/entries/getAllEntries/page:#{page_no}/sort:Entry.#{sort}/direction:#{direction}.json"
      #entries = begin
        result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
        if JSON.parse(result.body)['error'].nil?
          self.succefull_response(result)
        else
          method = __method__.to_s
          self.signature_check(method, options)
        end
      #rescue StandardError, Timeout::Error, SocketError => error
      #    error_report(:class_name => self.to_s, :exception => error)
      #end
      #entries
    end
  end

  # if provided without params, returns all entries.
  # User may provide other options in hash.
  def self.get_entry_by_id(options = {})
    tags = %w{votigo slides slides_single-entry}
    cache_name = "slides_single_entry_#{options.values.join('_')}"
    astro_cache(cache_name, :tags => tags, :expires_in => 5.minutes) do
      params = {:signature => @@signature}.merge(options)
      prefix = "/entries/getEntryById.json"
      #entry = begin
        result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
        unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
          self.succefull_response(result)
        else
          method = __method__.to_s
          self.signature_check(method, options)
        end
      #rescue StandardError, Timeout::Error, SocketError => error
      #    error_report(:class_name => self.to_s, :exception => error)
      #end
      #entry
    end
  end

  def self.remove_entry(options)
    params = {:signature => @@signature }.merge(options)
    prefix = "/Entries/removeEntry.json"
    response = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.remove_entry(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    response
  end
  
  def self.add_rating(options = {}, signature)
    # This function is used to add a vote to entry if vote is submitted successfully it returns
    # status 1, entry otherwise status 0 with message.
    # A hash with keys entry_id, rating (some value), user_id(if user login is required), session_id(if
    # user login is required), and cookie_id(if user login is not required) must be provided.
    params = {:signature => signature }.merge(options)
    prefix = "/Votes/addRating.json"
    rating = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    rating
  end

  # This function is used to add a vote to entry if vote is submitted successfully it returns
  # status 1, agreeText otherwise status 0 with message.
  # A hash with keys entry_id, vote_type(with value love_it / leave_it), user_id(if user login is required), session_id(if
  # user login is required), and cookie_id(if user login is not required) must be provided.
  def self.add_vote(options = {})
    params = {:signature => @@signature}.merge(options)
    prefix = "/Votes/addVote.json"
    vote = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        method = __method__.to_s
        self.signature_check(method, options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    @@scount == 0 ? vote : "Signature Error"
  end

  def self.add_entry_comment(options, signature)
    # A hash with keys contest_id and user_id must be provided.
    params = {:signature => signature }.merge(options)
    prefix = "/comments/addEntryComment.json"
    comment = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      self.succefull_response(result)
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    comment
  end

  def self.get_user_entries_by_id(options)
    params = {:signature => @@signature }.merge(options)
    prefix = "/users/getUserEntriesByUserId.json"
    user_entries = begin
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      unless JSON.parse(result.body)['error'] == "Invalid Signature"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.get_user_entries_by_id(options)
      end
    rescue StandardError, Timeout::Error, SocketError => error
        error_report(:class_name => self.to_s, :exception => error)
    end
    user_entries
  end

  def self.get_signature
    params = {:apiKey => User.votigo_api_key}
    prefix = "/api/signature.json"
    result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
    JSON.parse(result.body)["signature"]
  end

  def self.entry_already_voted?(entry_id, user_id, session_id)
    tags = %w{votigo slides slides_single-vote-entry}
    cache_name = "slides_single_vote_entry_#{entry_id}_#{user_id}_#{session_id}"
    astro_cache(cache_name, :tags => tags, :expires_in => 10.minutes) do
      params = {:signature => @@signature, :user_id => user_id, :session_id => session_id, :entry_id => entry_id }
      prefix = "/entries/getEntryById.json"
      result = self.http_request(:params => params, :prefix => prefix, :site => User.votigo_server)
      entry = unless JSON.parse(result.body)['error'] == "Invalid Signature" || JSON.parse(result.body)['error'] == "Signature Expired"
        self.succefull_response(result)
      else
        @@signature = get_signature
        self.entry_already_voted?(entry_id, user_id, session_id)
      end
      if entry && entry["Entry"] && entry["Entry"]["User"] && entry["Entry"]["User"]["already_voted"] && entry["Entry"]["User"]["already_voted"].to_i == 0
        return false
      else
        return true
      end
    end
  end

  def self.signature_check(method, options)
    if @@scount < 3
      @@scount +=1
      @@signature = get_signature
      self.send(method,options)
    else
      @@serror = "Signature Error"
    end
  end

  private

  def self.succefull_response(result)
    @@scount = 0
    JSON.parse(result.body)
  end

  def self.restclient_request(options)
    RestClient.post("#{options[:site]}#{options[:prefix]}", options[:params])
  end

  def self.generic_request(method, prefix, params, &block)
    raise "Block should be given" unless block_given?
    result = if method == :get
      http_request(:site => User.lasso_server, :prefix => prefix, :params => params)
    else
      http_post_request(params, :site => User.lasso_server, :prefix => prefix)
    end
    match = result.body.match(/status=(\w+)/)
    if match
      block.call(match[1], result.body)
    end
  rescue Errno::ECONNREFUSED => error
    raise Errors::ConnectionError
  end

end