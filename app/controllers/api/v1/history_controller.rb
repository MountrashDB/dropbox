class Api::V1::HistoryController < AdminController
  before_action :check_user_token, only: [
                                     :index,
                                   ]

  def index
    history = @current_user.histories.order(created_at: :desc).limit(20)
    # render json: HistoryBlueprint.render(history)
    render json: history
  end
end
