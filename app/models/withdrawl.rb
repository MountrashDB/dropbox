# == Schema Information
#
# Table name: withdrawls
#
#  id                  :bigint           not null, primary key
#  amount              :float(24)
#  kodeBank            :string(255)
#  nama                :string(255)
#  rekening            :string(255)
#  status              :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  mitra_id            :integer
#  mitratransaction_id :integer
#  user_id             :bigint
#  usertransaction_id  :bigint
#
# Indexes
#
#  index_withdrawls_on_user_id             (user_id)
#  index_withdrawls_on_usertransaction_id  (usertransaction_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (usertransaction_id => usertransactions.id)
#
class Withdrawl < ApplicationRecord
  include AASM

  belongs_to :user, optional: true
  belongs_to :usertransaction, optional: true

  belongs_to :mitra, optional: true
  belongs_to :mitratransaction, optional: true
  validates_numericality_of :amount, greater_than_or_equal_to: 10000

  after_create :send_money

  @@fee = Rails.application.credentials.linkqu[:fee]

  aasm column: :status do
    state :requesting, initial: true
    state :complete, :failed

    event :gagal, after_commit: :reverse_balance do
      transitions from: :requesting, to: :failed
    end

    event :success do
      transitions from: :requesting, to: :complete
    end
  end

  def reverse_balance
    user = User.find(self.user_id)
    balance = user.usertransactions.balance
    trx = Usertransaction.create!(
      user_id: self.user_id,
      credit: self.amount + @@fee,
      debit: 0,
      balance: balance + self.amount + @@fee,
      description: "Failed Withdraw",
    )
  end

  def send_money
    SendMoneyJob.perform_at(5.seconds.from_now, self.id)
  end
end
