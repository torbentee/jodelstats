module ApplicationHelper
  def random_color
    ["DD5F5F", "9EC41C", "06A3CB", "FF9908", "8ABDB0"].sample(1)[0]
  end

  def locale_param
    "?locale=#{I18n.locale}"
  end
end
