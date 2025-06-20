module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request, only: [ :token ]

      def token
        client_id = params[:client_id]
        api_key = params[:api_key]

        begin
          token = JwtService.new.generate_token(client_id, api_key)
        rescue StandardError => e
          puts e.message
          render json: { error: "Internal server error" }, status: :internal_server_error
          return
        end

        if token
          render json: { token: token, expires_in: 24.hours.to_i }, status: :ok
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end
    end
  end
end
