class Api::V1::HistoryController < AdminController
  before_action :check_user_token, only: [
                                     :index,
                                   ]  

  def index
    if params[:title]
      history = @current_user.histories.where(title: params[:title]).order(created_at: :desc).limit(20)
    else
      history = @current_user.histories.order(created_at: :desc).limit(20)
    end
    render json: history
  end
end
