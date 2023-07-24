class Api::V1::HistoryController < AdminController
  before_action :check_user_token, only: [
                                     :index,
                                   ]

  def index
    history = @current_user.histories.order(created_at: :desc).limit(5)
    render json: HistoryBlueprint.render(history)
  end
end