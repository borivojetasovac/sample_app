module ApplicationHelper

  # Returns the full title on a per-page basic.
  def full_title(page_title = '')                     # Optional argument
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title                                      # Implicit return
    else
      page_title + " | " + base_title
    end
  end
end
