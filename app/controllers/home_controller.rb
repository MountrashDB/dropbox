class HomeController < ApplicationController
    def index
        render json: {message: "Server is running"}
    end
end
