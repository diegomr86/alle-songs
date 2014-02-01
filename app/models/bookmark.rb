class Bookmark < ActiveRecord::Base
  belongs_to :user

  validates :value, uniqueness: true, uniqueness: { scope: :user }
end
