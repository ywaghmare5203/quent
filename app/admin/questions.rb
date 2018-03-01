ActiveAdmin.register Question do


permit_params :name, option_catalogues_attributes: [:option_text, :_destroy => true]

  index do
    selectable_column
    column :id
    column :name
    column :option_text
    actions
  end
  
  filter :name


  form  do |f|
    f.inputs 'Question' do
      f.semantic_errors
      f.input :name, :require => true
    end

    f.inputs "Options" do
      f.has_many :option_catalogues do |i|
        i.input :option_text
      end 
    end
    f.actions
  end


end

	