Votigo::Application.routes.draw do

  def deep_copy(hash)
    Marshal::load(Marshal::dump(hash))
  end

  routes = [
    { "/slides" => 'slides#index', :as => :slides  },
    { "/welcome" => 'users#welcome', :as => :welcome  },
    { "/redirect" => 'users#fb_redirect', :as => :fb_redirect  },
    { "/index" => 'users#index', :as => :index_pr  },
    { "/slides/:id" => 'slides#slide', :as => :slide  },
    { "/gallery" => 'slides#gallery', :as => :gallery },
    { "/next_slides" => 'slides#next_slides', :as => :next_slides },
    { "/next_slide/:id" => 'slides#next_slide', :as => :next_slide  },
    { "/next_page" => 'slides#next_page', :as => :next_page },
    { "/vote" => 'slides#vote_entry', :as => :vote_entry  },
    { "/new" => "users#new", :as => :users_new },
    { "/register" => "users#create", :as => :users_register  },
    { "/ajax/user/sign-up" => "users#sso_create", :as => :users_sso_register },
    { "/update" => "users#update", :as => :users_update  },
    { '/logout' => 'sessions#destroy', :as => :logout  },
    { '/user/login' => 'sessions#new', :as => :session_new  },
    { '/ajax/user/sign-in' => 'sessions#new', :as => :session_ajax_new  },
    { '/ajax/user/sign-out' => 'sessions#destroy', :as => :session_ajax_destroy  },
    { '/ajax/user/set-newsletters' => 'users#newsletters', :as => :users_newsletters  },
    { '/ajax/sso-html/:type' => 'sessions#fetch_form', :as => :session_fetch_form },
    { '/ajax/gigya/login' => 'sessions#gigya_login', :as => :session_gigya_login  },
    { '/ajax/social/email' => 'sessions#social_email', :as => :social_email },
    { '/ajax/gigya/register' => 'users#gigya_register', :as => :gigya_register  },
    { '/create' => 'sessions#create', :as => :session_create },
    { '/contest-image' => 'users#contest_image', :as => :image_form },
    { '/uploadimage' => 'users#upload_image', :as => :image_upload  },
    { '/user/remote_validations' => "users#remote_validations", :as => :users_remote_validations  },
    { '/redirection' => 'sessions#redirection', :as => :session_redirection  },
    { '/' =>  "users#welcome", :as => :root }
  ]

  staging_routes = deep_copy(routes)


  constraints :domain => /(#{AppConfig['domains'].join('|')})/ do

    routes.each do |route|
      key = route.keys.find { |k| k != :as && k != :constraints }
      obj = route.delete(key)
      route_as = route[:as]
      CONTESTS['contests'].each do |k,v|
        route["/photo-contests/#{k}#{key}"] = obj
        route[:as] = "#{route_as}_#{k.gsub('-','_')}_with_prefix"
        match(route)
      end
    end
  end



  staging_routes.each do |route|
    key = route.keys.find { |k| k != :as && k != :constraints }
    obj = route.delete(key)
    route_as = route[:as]
    CONTESTS['contests'].each do |k,v|
      route["/staging/photo-contests/#{k}#{key}"] = obj
      route[:as] = "#{route_as}_#{k.gsub('-','_')}_staging_with_prefix"
      match(route)
    end
  end



end
