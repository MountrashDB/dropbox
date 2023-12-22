# Preview all emails at http://localhost:3000/rails/mailers/outlet_mailer
class OutletMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/outlet_mailer/forgot_password
  def forgot_password
    OutletMailer.forgot_password
  end

end
