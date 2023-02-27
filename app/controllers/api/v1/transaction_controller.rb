class Api::V1::TransactionController < ApplicationController
    def upload
        
        render json: {message: params[:uuid]}
    end
end