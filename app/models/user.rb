class User < ApplicationRecord
	has_secure_password validations: true
	mount_uploader :image, ImageUploader

	validates :name,{presence: true}
	validates :email,{presence: true, uniqueness: true}
   
	has_many :posts, dependent: :destroy
    has_many :likes, dependent: :destroy

	def posts
		return Post.where(user_id: self.id)
	end


end
