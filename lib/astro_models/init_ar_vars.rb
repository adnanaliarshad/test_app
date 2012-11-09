# Set class variables to models from config/env_configs dir. This is how we did:
# Drupal.site = "blabla"
# Drupal.prefix = "blabla"
# before, I just moved these settings to separate files and include them by the code below.
module AstroModels::InitArVars

  def init_ar_vars
    config = YAML.load_file("#{Rails.root}/config/env_configs/#{Rails.env.downcase}.yml")
    keys = self.to_s.underscore.split("/")
    values = keys.inject(nil) do |hash, key|
      hash ||= config
      hash = hash[key]
      hash
    end
    (values || {}).each do |key, value|
      self.send("#{key}=", value)
    end
  end

end
