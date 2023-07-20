class HistoryBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :description, :amount, :created_at
end
