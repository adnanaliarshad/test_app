module SlidesHelper

  def already_voted?(entry_id)
    Users::Votigo.entry_already_voted?(entry_id, @current_user.votigo.id, @current_user.votigo.session_id)
  end

  def contest_url(url)
    link = request.url + "/" unless request.url == '/'
    contest_name = link.match(/photo-contests\/.*?\//).to_s.split("/")[1].split("?")[0]
    if request.url.include?("photo-contests/") and url != "" and CONTESTS['contests'].include?(contest_name)
      "/photo-contests/#{contest_name}" + url
    else
      url
    end
  end

end