class WithdrawlBlueprint < Blueprinter::Base
  identifier :id
  fields :amount, :kodeBank, :nama, :rekening, :status, :created_at, :updated_at
  association :user, blueprint: UserBlueprint, view: :withdraw
  association :mitra, blueprint: MitraBlueprint
end
