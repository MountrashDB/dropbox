class HistoryBlueprint < Blueprinter::Base
  identifier :id

  fields :title, :desc, :amount, :created_at
end
