class SendMoneyJob
  include Sidekiq::Job

  def perform(*args)
    puts "=== Job Send Money ==="
  end
end
