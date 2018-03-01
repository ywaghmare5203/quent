class Interest < ApplicationRecord
  has_attached_file :imedia, { url: "/system/Interest/:id/imedia/#{Digest::SHA256.base64digest("yogesh")[0..20]}/interest.:extension"}
  validates_attachment_content_type :imedia, content_type: /\Aimage/
  validates_attachment_file_name :imedia, matches: [/png\z/, /jpe?g\z/]
  do_not_validate_attachment_file_type :imedia

   def imedia_url
   	   imedia.url.dup.prepend("https://quneat-dev.herokuapp.com")
    end
end
