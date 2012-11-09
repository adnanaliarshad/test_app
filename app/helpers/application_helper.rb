module ApplicationHelper
  include BirthFieldsHelpers
  include FieldHelpers
  include JavascriptHelpers
  include UsersHelper
  include AstroCache::Interface

  def is_subscribed?(newsletter_id)
    subscribers = Users::Arwen.subscribers_to_newsletter(newsletter_id, @current_user.arwen_id)
    subscribers.include?(@current_user.arwen_id)
  end

  def contest_name
    javascript_tag("
    Votigo.contest_name = '#{@contest['tracking_name']}';
    ")
  end

end
