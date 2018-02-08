class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :profile_photo, :styles => { :medium => "238x238>", 
                                   :thumb => "100x100>"
                                 }

  has_attached_file :cover_photo, :styles => { :medium => "238x238>", 
                                   :thumb => "100x100>"
                                 }
end
