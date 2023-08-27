class BanksampahMailer < ApplicationMailer
  default from: "cs@smartdropbox.online"

  def welcome_email(model)
    @model = model
    mail(to: @model.email, subject: "Bank Sampah activation code")
  end
end
