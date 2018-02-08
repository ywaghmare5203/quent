ActiveAdmin.register User do
 permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :provider
    column :uid
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      #t.input :profile_photo
      f.input :profile_photo, :as => :file, :hint => f.template.image_tag(f.object.profile_photo.url(:medium))
      f.input :cover_photo, :as => :file, :hint => f.template.image_tag(f.object.cover_photo.url(:medium))
    end
    f.actions
  end


end
