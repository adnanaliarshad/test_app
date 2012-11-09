require 'nokogiri'

class User

  #include AstroModels::Users::Validation

  attr_reader :errors
  attr_accessor :password, :password_confirmation, :old_password
  attr_accessor :arwen, :votigo

  cattr_accessor :ivillage_server, :votigo_server, :votigo_api_key, :arwen_host, :arwen_user, :arwen_password
  extend AstroModels::InitArVars
  init_ar_vars


  attr_accessor :username, :gender, :first_name, :last_name, :email, :language, :country, :other_url, :postal_code, :birth_date,
                :votigo_session_id, :image_title, :image_description, :arwen_id, :votigo_id, :subscriptions


  ACCESSOR_METHODS = %w{ username gender first_name last_name email language country other_url postal_code birth_date
                        votigo_session_id, image_title image_description
                       }

  def initialize(options = {})
    @errors = {}
    @methods_for_validation = []
    @arwen = Users::Arwen.new
    @votigo = Users::Votigo.new
    subs = {}
    CONTESTS["contests"][options[:contest]]['newsletters'].each do |items|
      subs["#{items[1]}"] = ""
    end
    self.subscriptions = subs
    unless options["uuid"].nil?
      @arwen = Users::Arwen.find_user(options)
      unless @arwen.uuid.blank?
        @votigo = Users::Votigo.social_login({"social_id" => @arwen.uuid})
        if @votigo.nil?
          Users::Votigo.social_create(options.merge("username" => @arwen.nick, "social_id" => @arwen.uuid, "email" => @arwen.email))
          @votigo = Users::Votigo.social_login({"social_id" => @arwen.uuid})
        end
        @votigo = @votigo
      end
    end
    sync_arwen_votigo_attributes
  end


  def self.find(options = {})
    new(options)
  end


  def valid?
    validate
  end

  def create_update_user

  end

  def attributes=(attrs = {})
    self.arwen_id = attrs['uuid'] unless attrs['uuid'].blank?
    self.username = attrs['username'] unless attrs['username'].blank?
    self.last_name = attrs['last_name'] unless attrs['last_name'].blank?
    self.first_name = attrs['first_name'] unless attrs['first_name'].blank?
    self.email = attrs['email'] unless attrs['email'].blank?
    self.gender = attrs['gender'] unless attrs['gender'].blank?
    self.birth_date = attrs['birth_date'] unless attrs['birth_date'].blank?
    self.country = attrs['country'] unless attrs['country'].blank?
    self.postal_code = attrs['postal_code'] unless attrs['postal_code'].blank?
    self.other_url = attrs['other_url'] unless attrs['other_url'].blank?
    self.votigo_session_id = attrs['votigo_session_id'] unless attrs['votigo_session_id'].blank?
    self.language = attrs['language'] unless attrs['language'].blank?
    self.password = attrs['password'] unless attrs['password'].blank?
    self.votigo_id = attrs['votigo_id'] unless attrs['votigo_id'].blank?
  end

  def sync_arwen_votigo_attributes
    self.arwen_id = @arwen.uuid unless @arwen.uuid.nil?
    self.username = @arwen.nick unless @arwen.nick.nil?
    self.last_name = @arwen.last_name unless @arwen.last_name.nil?
    self.first_name = @arwen.first_name unless @arwen.first_name.nil?
    self.email = @arwen.email unless @arwen.email.nil?
    self.gender = @arwen.gender unless @arwen.gender.nil?
    self.birth_date = Date.parse(@arwen.birthdate) unless @arwen.birthdate.nil?

    unless @votigo.nil?
      self.country = @votigo.country unless @votigo.country.nil?
      self.postal_code = @votigo.postal_code unless @votigo.postal_code.nil?
      self.votigo_session_id = @votigo.session_id unless @votigo.session_id.nil?
      self.other_url = @votigo.other_url unless @votigo.other_url.nil?
      self.language = @votigo.language unless @votigo.language.nil?
      self.votigo_id = @votigo.id unless @votigo.id.nil?
    end
  end

  def changed
    @engine.changed
  end

  def self.authenticate(email, password)
    begin
      @arwen = Users::Arwen.login({ "email" => email, "password" => password })
#      @votigo = Users::Votigo.login({ "email" => email, "password" => password }, signature)
      @votigo = Users::Votigo.social_login({"social_id" => @arwen.uuid})

    rescue Users::Arwen::Errors::WrongEmail
      raise InvalidEmail
    rescue Users::Arwen::Errors::WrongPassword, Users::Votigo::Errors::WrongPassword
      raise InvalidPassword
    rescue Users::Arwen::Errors::UnknownStatus
      logger.error("Lasso responds by unknown status during login")
      return nil
    end
#    sync_arwen_votigo_attributes
    @arwen.uuid
  end

  def logged_in?
    !@arwen.uuid.nil?
  end

  def create
    options = { "email" => self.email, "username" => self.email.gsub("@","_"),
    "dob" => self.birth_date.strftime("%m/%d/%Y"), "first_name" => self.first_name,
    "last_name" => self.last_name, "gender" => self.gender, "password" => self.password }
    self.arwen_id = Users::Arwen.create_user(options)
    # signature = Users::Votigo.get_signature
    votigo = Users::Votigo.social_create(options.merge({"social_id" => self.arwen_id, "country" => self.country,
             "language" => self.language, "postal_code" => self.postal_code}))
    self.votigo_id = votigo['User']['id']
    true
  rescue Users::Arwen::Errors::DuplicatedEmail, Users::Votigo::Errors::DuplicatedEmail
    @errors[:email] = "already existed"
    false
  rescue Users::Arwen::Errors::DuplicatedNick, Users::Votigo::Errors::DuplicatedNick
    @errors[:nick] = "already existed"
    false
  end


  def sso_create
    self.arwen_id = Users::Arwen.create_user(options)
    # signature = Users::Votigo.get_signature
    votigo = Users::Votigo.social_create(options.merge({"social_id" => self.arwen_id, "country" => self.country,
             "language" => self.language, "postal_code" => self.postal_code}))
    self.votigo_id = votigo['User']['id']
    true
  rescue Users::Arwen::Errors::DuplicatedEmail, Users::Votigo::Errors::DuplicatedEmail
    @errors[:email] = "already existed"
    false
  rescue Users::Arwen::Errors::DuplicatedNick, Users::Votigo::Errors::DuplicatedNick
    @errors[:nick] = "already existed"
    false
  end


  def update
    options = {}
    options["first_name"] = self.first_name
    options["last_name"] = self.last_name
    options["gender"] = self.gender
    options["birthdate"] = self.birth_date
    options["uuid"] = self.arwen_id
    Users::Arwen.update_user(options)
    Users::Votigo.update({"first_name" => self.first_name, "last_name" => self.last_name,
                         "session_id" => self.votigo_session_id, "gender" => self.gender, "user_id" => self.votigo_id})
    true
  end

end
