module JodelCityHelper
  def get_first_jodel(city)
    jodel = city.jodel_posts.order(vote_count: :desc).first
    if jodel.nil?
      jodel = JodelPost.new(vote_count: 0, message: "(Ups, keinen Jodel gefunden. Versuch es doch in ein paar Minuten noch einmal!)",
      color: "404040")
    end
    return jodel
  end
end
