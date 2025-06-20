class ApplicationController < ActionController::API
  include ErrorHandler

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    unless token && JwtService.new.authorized_client?(token)
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end
end
