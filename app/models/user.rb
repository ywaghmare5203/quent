class User < ApplicationRecord
  has_secure_password
  # Validations
  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :username, :email
  has_attached_file :profile_photo
  has_attached_file :cover_photo
 # Validate content type
  validates_attachment_content_type :profile_photo, content_type: /\Aimage/
  validates_attachment_content_type :cover_photo, content_type: /\Aimage/
  # Validate filename
  validates_attachment_file_name :profile_photo, matches: [/png\z/, /jpe?g\z/]
  validates_attachment_file_name :cover_photo, matches: [/png\z/, /jpe?g\z/]
  # Explicitly do not validate
  do_not_validate_attachment_file_type :profile_photo
  do_not_validate_attachment_file_type :cover_photo


  def self.profile_photo(encode_image)
  	  profile = StringIO.new(Base64.decode64(encode_image))
      profile.class.class_eval { attr_accessor :original_filename , :content_type }
      profile.original_filename = "profile_photo.jpg"
      profile.content_type = "image/jpg"
      user.profile_photo = io
  end
  
end


