module UsersHelper

  def users_path_builder(method, opts = {})
    users_builder(method, opts, "path")
  end

  def users_url_builder(method, opts = {})
    users_builder(method, opts, "url")
  end

  def users_builder(method, opts, path_type)
    dup_params = params.dup.delete_if {|key, value|
      %W{authenticity_token signed_request}.include?(key)
    }
    link = request.url + "/" unless request.url == '/'
    contest_name = link.match(/photo-contests\/.*?\//).to_s.split("/")[1].split("?")[0]
    if respond_to?(:request) && AppConfig['domains'].join('|').include?(request.domain) && !(link.include?("playard") || link.include?("staging"))
      send("#{method}_#{contest_name.gsub('-','_')}_with_prefix_#{path_type}", dup_params.merge(opts))
    elsif respond_to?(:request) && "akamai.net".include?(request.domain)
      send("#{method}_#{contest_name.gsub('-','_')}_with_akamai_prefix_#{path_type}", dup_params.merge(opts))
    elsif respond_to?(:request) && (link.include?("playard") || link.include?("staging"))
      send("#{method}_#{contest_name.gsub('-','_')}_staging_with_prefix_#{path_type}", dup_params.merge(opts))
    else
      send("#{method}_#{contest_name.gsub('-','_')}_#{path_type}", dup_params.merge(opts))
    end
  end

  def can_do_entry_submission_by_email?(contest, email)
    if email.blank?
      true
    else
      Users::Votigo.can_do_entry_submission?({:email => email}, contest)
    end
  end

end
