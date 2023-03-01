class ApiController < ApplicationController
    if Rails.env.production?
      rescue_from Exception, :with => :error_generic
    end
    skip_before_action :verify_authenticity_token
end