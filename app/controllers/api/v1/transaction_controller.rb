class Api::V1::TransactionController < ApplicationController
  def upload
    render json: { message: params[:uuid] }
  end

  def update_botol
    transaction = Transaction.find_by(uuid: params[:uuid])
    if transaction
      if botol = Botol.find_by(uuid: params[:botol_uuid])
        transaction.botol_id = botol.id
        if transaction.save
          render json: { message: "Saved" }
        else
          render json: transaction.errors
        end
      else
        render json: { message: "Botol not found" }, status: :not_found
      end
    else
      render json: { message: "Transaction not found" }, status: :not_found
    end
  end
end
