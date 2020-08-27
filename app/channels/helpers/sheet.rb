# frozen_string_literal: true

class Helpers::Sheet < Helpers::Base
  def add(data)
    responds(Sheets::Create, params.merge(data).merge(owner_id: current_user.id)) do |sheet|
      broadcast(new: true, sheet: sheet_serializer(sheet))
    end
  end

  def change(data)
    return broadcast(errors: 'No permission') unless allowed_to?(:write?, by_data(data))

    responds(Sheets::Update, params.merge(data)) do |sheet|
      SheetChannel.broadcast_to(sheet, sheet_serializer(sheet))
      broadcast(update: true, sheet: sheet_serializer(sheet))
    end
  end

  def remove(data)
    sheet = by_data(data)
    return broadcast(errors: 'sheet not found') if sheet.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:remove?, sheet)

    sheet.destroy
    SheetChannel.broadcast_to(sheet, delete: sheet.id)
    broadcast(delete: true, sheet: sheet.id)
  end

  def change_access(data)
    sheet = by_data(data)
    return broadcast(errors: 'sheet not found') if sheet.nil?
    return broadcast(errors: 'No permission') unless allowed_to?(:change_access?, sheet)

    responds(Acl::Access, params.merge(data)) do |item|
      broadcast(access: true, sheet: sheet_serializer(item))
    end
  end

  private

  def by_data(data)
    Sheet.find_by(id: data['id'])
  end

  def sheet_serializer(item)
    SheetSerializer.new(item)
  end
end