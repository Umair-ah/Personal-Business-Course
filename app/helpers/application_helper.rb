module ApplicationHelper
  def active?(path)
    if current_page?(path)
      "active"
    end
  end
end
