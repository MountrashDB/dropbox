# == Schema Information
#
# Table name: investors
#
#  id          :bigint           not null, primary key
#  balance     :float(24)
#  credit      :float(24)
#  debit       :float(24)
#  description :string(255)
#  status      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Investor < ApplicationRecord
  scope :balance, -> { pluck(:balance).last || 0 }
  include AASM

  aasm column: :status do
    state :income, initial: true
    state :paid, :failed

    event :paidkan do
      transitions from: :income, to: :paid
    end

    event :failedkan do
      transitions from: :income, to: :failed
    end
  end

  def self.creditkan(amount, description = "")
    balance = Investor.balance
    record = Investor.create!(
      credit: amount,
      debit: 0,
      balance: balance + amount,
      description: description,
    )
  end

  def self.debitkan(amount, description = "")
    balance = Investor.balance
    record = Investor.create!(
      credit: 0,
      debit: amount,
      balance: balance - amount,
      description: description,
    )
  end
end
