class Question < ApplicationRecord
	has_many :option_catalogues
	accepts_nested_attributes_for :option_catalogues#, :allow_destroy => true

  has_attached_file :question_media, { url: "/system/Question/:id/question_media/#{Digest::SHA256.base64digest("yogesh")[0..20]}/interest.:extension"}
  validates_attachment_content_type :question_media, content_type: /\Aimage/
  validates_attachment_file_name :question_media, matches: [/png\z/, /jpe?g\z/]
  do_not_validate_attachment_file_type :question_media
end
