class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }   # Order from newest to oldest.
  mount_uploader :picture, PictureUploader        # CarrierWave associate the uploaded image with a model (attribute and the class name fo the uploader)
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
