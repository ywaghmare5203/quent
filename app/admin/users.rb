ActiveAdmin.register User do
 permit_params :email, :password, :password_confirmation, :profile_photo, :cover_photo, :status

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
      f.input :username
      f.input :email
      f.input :mobile
      f.input :password
      f.input :password_confirmation
      f.inputs "Upload" do
        f.input :profile_photo, required: true, as: :file
        f.input :cover_photo, required: true, as: :file
      end
      f.input :status
    end
    f.actions
  end
end
