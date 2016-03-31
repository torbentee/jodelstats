module JodelCityHelper
  def get_first_jodel(city)
    jodel = city.jodel_posts.order(vote_count: :desc).first
    if jodel.nil?
      jodel = JodelPost.new(vote_count: 0, message: I18n.t('no_jodel_found'),
      color: "404040")
    end
    return jodel
  end
end
