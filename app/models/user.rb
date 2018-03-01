class User < ApplicationRecord
  has_secure_password
  # Validations
  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :username, :email
  has_attached_file :profile_photo, { url: "/system/User/:id/profile_photo/#{Digest::SHA256.base64digest("yogesh")[0..20]}/profile_photo.:extension"}
  has_attached_file :cover_photo , { url: "/system/User/:id/cover_photo/#{Digest::SHA256.base64digest("yogesh")[0..20]}/cover_photo.:extension"}
  before_save :downcase_email
  #before_create :generate_confirmation_instructions
 # Validate content type
  validates_attachment_content_type :profile_photo, content_type: /\Aimage/
  validates_attachment_content_type :cover_photo, content_type: /\Aimage/
  # Validate filename
  validates_attachment_file_name :profile_photo, matches: [/png\z/, /jpe?g\z/]
  validates_attachment_file_name :cover_photo, matches: [/png\z/, /jpe?g\z/]
  # Explicitly do not validate
  do_not_validate_attachment_file_type :profile_photo
  do_not_validate_attachment_file_type :cover_photo


  def downcase_email
    self.email = self.email.delete(' ').downcase
  end

  def self.profile_photo_url(profile_photo)
     profile_photo.url.dup.prepend("https://quneat-dev.herokuapp.com")
  end

  def self.cover_photo_url(cover_photo)
     cover_photo.url.dup.prepend("https://quneat-dev.herokuapp.com")
  end

  #def generate_confirmation_instructions
  #  self.confirmation_token = generate_token
  #  self.confirmation_sent_at = Time.now.utc
  #end

  def generate_confirmation_instructions
    self.confirmation_token = generate_token
    self.confirmation_sent_at = Time.now.utc
  end

  def confirmation_token_valid?
    (self.confirmation_sent_at + 30.days) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save!
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 24.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save
  end

  def update_new_email!(email)
    self.unconfirmed_email = email
    self.generate_confirmation_instructions
    save
  end

  def self.email_used?(email, id)
    existing_user = User.where(email: email, id: id )
    if !existing_user.present?
      return true
    else
      return false
    end
  end

#  def update_new_email!
#    self.email = self.unconfirmed_email
#    self.unconfirmed_email = nil
#    self.mark_as_confirmed!
#  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end


