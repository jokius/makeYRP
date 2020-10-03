# frozen_string_literal: true

class Helpers::SheetFolder < Helpers::Base
  def add(data)
    responds(Sheets::Folders::Create, params.merge(data).merge(owner_id: current_user.id)) do |folder|
      broadcast(new: true, sheet_folder: folder_serializer(folder))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Sheets::Folders::Update, params.merge(data)) do |folder|
      broadcast(update: true, sheet_folder: folder_serializer(folder))
    end
  end

  def remove(data)
    folder = by_data(data)
    return broadcast(errors: 'sheet folder not found') if folder.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, folder)

    folder.destroy unless folder.root?
    broadcast(delete: true, sheet_folder: true, id: folder.id)
  end

  private

  def by_data(data)
    Games::SheetFolder.find_by(id: data['id'])
  end

  def folder_serializer(item)
    Sheets::FolderSerializer.new(item)
  end
end
