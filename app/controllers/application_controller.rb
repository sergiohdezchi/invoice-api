class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    unless token && JwtService.authorized_client?(token)
      render json: { error: "Unauthorized access" }, status: :unauthorized
    end
  end
end
