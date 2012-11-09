module AstroModels::Thumbnails

  def thumbnail(size, image_url = @image_url)
    unless image_url.blank?
      image_url.gsub('/files/et/', '/files/et/imagecache/' + size.to_s + '/')
    end
  end


  def image_with_host(image)
    unless image.blank?
      site = self.class.images.gsub(/\/$/, '') + "/"
      site + image.to_s.gsub(/^\//, '')
    end
  end

end
