module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ArgumentError, with: :handle_argument_error
  end

  private

  def handle_argument_error(exception)
    render json: { error: "Invalid parameter format: #{exception.message}" },
            status: :unprocessable_entity
  end

  def handle_standard_error(exception)
    render json: { error: "An error occurred while processing your request." },
           status: :internal_server_error
  end
end
