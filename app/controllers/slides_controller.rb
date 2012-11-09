class SlidesController < ApplicationController

  include UsersHelper

  def index
    if flash[:lasso_notice]
      @notice = flash[:lasso_notice]
    else
      @notice = "welcome to slides"
    end
    @iv_subsection1 = "slide"
  end

  def gallery
    @entries = Users::Votigo.get_all_entries({:contest_id => @contest_id, :media_type => "photo", :limit => 6},
                                             "1", "created", "desc")
    @last_page = @total_pages = (@entries["total_count"].to_f/6).ceil
    @current_page = @first_page = 1
    session[:sort] = "new_created"
    session[:category] = ""
    if @current_page.to_i == @last_page
      @next_url = @last_url = ""
    else
      @next_url = users_path_builder(:next_page, {:page_no => @current_page + 1,
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
      @last_url = users_path_builder(:next_page, {:page_no => @last_page,
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
    end
    @first_url = @prev_url = ""
    unless @entries.blank?
      @entries["Entries"].each do |entry|
        voted = Users::Votigo.entry_already_voted?(entry["Entry"]["entry_id"], @current_user.votigo.id, @current_user.votigo.session_id)
        entry["Entry"].merge!({:already_voted => voted})
      end
    end
    @iv_subsection1 = "gallery"
  end

  def slide
    if params[:id]
      @entry = Users::Votigo.get_entry_by_id({:entry_id => params[:id], :user_id => @current_user.votigo.id, :session_id => @current_user.votigo.session_id})
      if @entry == "Signature Error"
        flash[:notice] = "Something went wrong please try again later."
        redirect_to users_path_builder(:welcome)
      end
    else
      redirect_to users_path_builder(:gallery)
    end
    @iv_subsection1 = "slide"
  end

  def next_page
    @current_page = params[:page_no] || 1
    session[:sort] = params[:sort].split('?')[0] || session[:sort] || "created"
    params[:direction] ||= "desc"
    params[:limit] ||= 6
    params[:category] ||= nil
    session[:category] = params[:category]
    options_hash = {:contest_id => @contest_id, :media_type => "photo", :limit => params[:limit]}
    options_hash.merge!({:category => params[:category]}) unless params[:category].nil?
    if session[:sort] == "new_created"
      @entries = Users::Votigo.get_all_entries(options_hash, @current_page, "created", "desc")
    else
      @entries = Users::Votigo.get_all_entries(options_hash, @current_page, session[:sort], params[:direction])
    end
    @first_page = 1
    @last_page = @total_pages = (@entries["total_count"].to_f/6).ceil
    if @current_page.to_i == @last_page
      @next_url = @last_url = ""
    else
      if session[:sort] == "new_created"
        @next_url = users_path_builder(:next_page, {:page_no => @current_page.to_i+1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
        @last_url = users_path_builder(:next_page, {:page_no => @last_page, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
      else
        @next_url = users_path_builder(:next_page, {:page_no => @current_page.to_i+1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "asc"})
        @last_url = users_path_builder(:next_page, {:page_no => @last_page, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "asc"})
      end
    end
    if @current_page.to_i == @first_page
      @prev_url = @first_url = ""
    else
      if session[:sort] == "new_created"
        @prev_url = users_path_builder(:next_page, {:page_no => @current_page.to_i - 1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
        @first_url = users_path_builder(:next_page, {:page_no => 1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "desc"})
      else
        @prev_url = users_path_builder(:next_page, {:page_no => @current_page.to_i - 1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "asc"})
        @first_url = users_path_builder(:next_page, {:page_no => 1, :category => params[:category],
                  :limit => 6, :sort => session[:sort], :direction => "asc"})
      end
    end
    @entries["Entries"].each do |entry|
      voted = Users::Votigo.entry_already_voted?(entry["Entry"]["entry_id"],@current_user.votigo.id,@current_user.votigo.session_id)
      entry["Entry"].merge!({:already_voted => voted})
    end
    if params[:signed_request].nil? and params[:facebook].nil?
      render :partial => "/framework/block/gallery/b_gallery_next_page"
    else
      render :partial => "/framework/block/gallery/facebook/b_gallery_next_page_fb"
    end
  end

  def next_slides
    params[:page_no] ||= 1
    params[:sort] ||= "created"
    params[:direction] ||= "desc"
    params[:limit] ||= 5

    if session[:sort] == "new_created"
      @entries = Users::Votigo.get_all_entries({:contest_id => @contest_id, :media_type => "photo", :limit => params[:limit]},
                                             params[:page_no], "created", "desc")
    else
      @entries = Users::Votigo.get_all_entries({:contest_id => @contest_id, :media_type => "photo", :limit => params[:limit]},
                                             params[:page_no], params[:sort], params[:direction])
    end
    if @entries == "Signature Error"
      render :json => {:error => @entries}
    else
      unless @entries.blank?
        @entries["Entries"].each do |entry|
          voted = Users::Votigo.entry_already_voted?(entry["Entry"]["entry_id"], @current_user.votigo.id, @current_user.votigo.session_id)
          entry["Entry"].merge!({:already_voted => voted})
        end
      end
      render :json => @entries
    end
  end

  def next_slide
    @entry = Users::Votigo.get_entry_by_id({:entry_id => params[:id], :user_id => @current_user.votigo.id, :session_id => @current_user.votigo.session_id})
    if @entry == "Signature Error"
      render :json => {:error => @entry}
    else
      if params[:signed_request].nil? and params[:facebook].nil?
        render :partial => "/framework/block/slides/b_single_slide"
      else
        render :partial => "/framework/block/slides/facebook/b_single_slide_fb"
      end
    end
  end

  def vote_entry
    cookies[:id] = cookies[:id] || rand(999999)
    unless @current_user.votigo.id.nil?
      user_id = params[:user_id] || @current_user.votigo.id
      session_id = params[:session_id] || @current_user.votigo.session_id
      user_hash = {:cookie_id => cookies[:id], :user_id => user_id, :session_id => session_id }
    else
      user_hash = { :cookie_id => cookies[:id], :user_id => "" }
    end

    vote_response = Users::Votigo.add_vote({:entry_id => params[:entry_id], :vote_type => params[:vote_type]}.merge(user_hash))
    begin
      if vote_response["status"].to_i == 1
        entry = Users::Votigo.get_entry_by_id({:entry_id => params[:entry_id]})
        vote_up = (entry["Entry"]["vote_count"].to_f/(entry["Entry"]["leave_it_count"].to_f+entry["Entry"]["vote_count"].to_f))*100
        vote_down = (entry["Entry"]["leave_it_count"].to_f/(entry["Entry"]["leave_it_count"].to_f+entry["Entry"]["vote_count"].to_f))*100
        render :json => { :vote => 1, :love_it => vote_up.to_i, :leave_it => vote_down.to_i,
                         :entry_id => params[:entry_id] }
      else
        render :json => { :vote => 0, :error => vote_response["error"] ||vote_response }
      end
    rescue StandardError, Timeout::Error, SocketError => error
        render :json => { :vote => 0, :error => "An error has occured please try again!" }
    end
  end

end