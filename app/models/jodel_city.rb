class JodelCity < ActiveRecord::Base
  has_many :jodel_posts, dependent: :destroy
  validates :name, presence: true
end
