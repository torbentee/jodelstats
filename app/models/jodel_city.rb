class JodelCity < ActiveRecord::Base
  has_many :jodel_posts, dependent: :destroy
  validates :name, presence: true

  def first_jodel
    jodel = self.jodel_posts.order(vote_count: :desc).first
    if jodel.nil?
      jodel = JodelPost.new(vote_count: 0, message: I18n.t('no_jodel_found'),
      color: "404040")
    end
    return jodel
  end

end
