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
  belongs_to :bank, optional: true, foreign_key: "kodeBank", primary_key: "kode_bank"
  validates_numericality_of :amount, greater_than_or_equal_to: 10000

  # after_create :send_money
  after_create :lock_transaction

  @@fee = ENV["linkqu_fee"].to_f

  aasm column: :status do
    state :requesting, initial: true
    state :complete, :failed, :sending, :rejected

    event :gagal, after_commit: :reverse_balance do
      transitions from: :sending, to: :failed
    end

    event :rejecting, after_commit: :refund_point do
      transitions from: :requesting, to: :rejected
    end

    event :approved, after_commit: :send_money do
      transitions from: :requesting, to: :sending
    end

    event :success, after_commit: :paid_transaction do
      transitions from: :sending, to: :complete
    end
  end

  # Rejection
  def reverse_balance
    user = User.find(self.user_id)
    desc = "Failed withdraw"
    total = self.amount + @@fee
    user.creditkan(total, desc)
    user.history_tambahkan(self.amount, "Withdraw failed", desc)
    Transaction.where(user: user, status: "requested").update(status: "in") # Rollback   
  end

  def refund_point
    user = User.find(self.user_id)
    desc = "Withdraw Rejected. Refunded"
    total = self.amount + @@fee
    user.creditkan(total, desc)
    user.history_tambahkan(self.amount, "Withdraw rejected", desc)
    Transaction.where(user: user, status: "requested").update(status: "in")
  end

  def send_money
    user = User.find(self.user_id)
    Transaction.where(user: user, status: "requested").update(status: "sending")
    SendMoneyJob.perform_at(2.seconds.from_now, self.id)
  end

  def lock_transaction
    user = User.find(self.user_id)
    transactions = Transaction.where(user: user, status: "in").update(status: "requested")
  end

  def paid_transaction
    user = User.find(self.user_id)
    transactions = Transaction.where(user: user, status: "requested").update(status: "paid")
  end
end
