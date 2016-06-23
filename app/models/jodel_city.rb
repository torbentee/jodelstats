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

  def to_param  # overridden
    name
  end

  def self.random
    self.offset(rand(self.count)).first
  end

  def self.random_except_for(name, country: country)
    puts country
    puts name
    if country
      otherCities = self.where.not(country: name)
      return otherCities.offset(rand(otherCities.count)).first
    else
      while(true)
        city = random
        return city if (city.name != name)
      end
    end
  end

end
