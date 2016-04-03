module JodelCityHelper
  def get_first_jodel(city)
    jodel = city.jodel_posts.order(vote_count: :desc).first
    if jodel.nil?
      jodel = JodelPost.new(vote_count: 0, message: I18n.t('no_jodel_found'),
      color: "404040")
    end
    return jodel
  end

  def full_country_name(abbr)
    case abbr
    when "DE"
      I18n.t(:germany)
    when "AT"
      I18n.t(:austria)
    when "CH"
      I18n.t(:switzerland)
    else
      abbr
    end
  end
end
