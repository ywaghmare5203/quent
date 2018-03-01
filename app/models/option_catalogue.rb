class OptionCatalogue < ApplicationRecord
  belongs_to :question
  has_attached_file :option_catalogues_media, { url: "/system/OptionCatalogue/:id/option_catalogues_media/#{Digest::SHA256.base64digest("yogesh")[0..20]}/interest.:extension"}
  validates_attachment_content_type :option_catalogues_media, content_type: /\Aimage/
  validates_attachment_file_name :option_catalogues_media, matches: [/png\z/, /jpe?g\z/]
  do_not_validate_attachment_file_type :option_catalogues_media
end
