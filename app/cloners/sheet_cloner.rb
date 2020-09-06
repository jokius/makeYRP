# frozen_string_literal: true

class SheetCloner < Clowne::Cloner
  adapter :active_record

  include_association :access_levels

  finalize do |source, record|
    record.name = "Копия #{source.name}"
  end
end
