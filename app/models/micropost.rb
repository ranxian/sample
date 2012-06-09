class Micropost < ActiveRecord::Base
  attr_accessible :content, :user_id
  validates_length_of :content, maximum: 140

  belongs_to :user
end
