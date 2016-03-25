class JodelCity < ActiveRecord::Base
  has_many :jodel_posts
  validates :name, presence: true
end
