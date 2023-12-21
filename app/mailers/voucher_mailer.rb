class VoucherMailer < ApplicationMailer
    default from: "cs@smartdropbox.online"
    
    def paid_email(model)
        @model = model        
        mail(to: @model.outlet.email, subject: "Kode langganan")
    end
end
