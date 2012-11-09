module AstroModels::Pagination

  def correct_page_number(page, per_page, total)
    page = 1 if page < 1
    last_page = (total.to_f / per_page.to_f).ceil
    last_page = 1 if last_page == 0 # If there are no records
    page = last_page if page > last_page
    page
  end

end
