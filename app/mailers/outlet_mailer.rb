class OutletMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outlet_mailer.forgot_password.subject
  #
  def forgot_password(model)
    @model = model
    mail(to: @model.email, subject: "Outlet forgot password")
  end
end
