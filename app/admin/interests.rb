ActiveAdmin.register Interest do
permit_params :name, :description, :imedia

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end

  filter :name

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.inputs "Upload" do
        f.input :imedia, required: true, as: :file
      end
    end
    f.actions
  end

end


