class ApplicationController < ActionController::API
  include ErrorHandler

  before_action :authenticate_request

  private

  def authenticate_request
    binding.irb
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    if token
      decoded = TokenGeneratorService.decode(token)
      if decoded && User.exists?(decoded[:user_id])
        @current_user = User.find(decoded[:user_id])
        return
      end
    end

    render json: { status: 'error', message: "No autorizado" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
