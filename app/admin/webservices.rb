ActiveAdmin.register Webservice do
permit_params :name, :url, :req_type, :status

  index do
    selectable_column
    id_column
    column :name
    column :url
    column :req_type
    column :status
    actions
  end

  filter :name
  filter :url
  filter :req_type
  filter :status

  form  do |f|
    f.inputs do
      f.input :name
      f.input :url
      f.input :req_type
      f.input :status
    end
    f.actions
  end

end
