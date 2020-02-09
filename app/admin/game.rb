# frozen_string_literal: true

ActiveAdmin.register Game do
  permit_params :name, :open

  index do
    id_column
    column :name
    column :open
    column :master
    column :system
    actions
  end

  filter :open
  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :open
    end

    f.actions
  end
end
