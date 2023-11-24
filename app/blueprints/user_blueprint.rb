class UserBlueprint < Blueprinter::Base
  identifier :id

  view :withdraw do
    fields :email, :username, :phone
  end

  view :order_sampah do
    fields :email, :username, :phone
  end

  view :register do
    fields :uuid, :email, :username, :active_code, :phone, :active
  end

  view :profile do
    fields :email, :name, :username, :phone, :uuid
    field :total_botol do |data|
      if data
        data.transactions.count
      else
        0
      end
    end

    field :balance do |data|
      if data
        data.usertransactions&.balance
      else
        0
      end
    end
  end
end
