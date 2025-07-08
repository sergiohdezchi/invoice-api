module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:register, :login]
      
      # POST /api/v1/auth/register
      def register
        user = User.new(user_params)
        
        if user.save
          token_service = TokenGeneratorService.new(user)
          token = token_service.generate_token
          expiration = Time.now + 24.hours
          
          render json: {
            status: 'success',
            message: 'Usuario registrado exitosamente',
            data: {
              user: {
                id: user.id,
                email: user.email,
                name: user.name
              },
              token: token,
              token_type: 'Bearer',
              expires_at: expiration.to_i
            }
          }, status: :created
        else
          render json: {
            status: 'error',
            message: 'Error al registrar usuario',
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])
        
        if user&.valid_password?(params[:password])
          token_service = TokenGeneratorService.new(user)
          token = token_service.generate_token
          expiration = Time.now + 24.hours
          
          render json: {
            status: 'success',
            message: 'Login exitoso',
            data: {
              user: {
                id: user.id,
                email: user.email,
                name: user.name
              },
              token: token,
              token_type: 'Bearer',
              expires_at: expiration.to_i
            }
          }, status: :ok
        else
          render json: {
            status: 'error',
            message: 'Credenciales inválidas'
          }, status: :unauthorized
        end
      end
      
      # DELETE /api/v1/auth/logout
      def logout
        render json: {
          status: 'success',
          message: 'Sesión cerrada correctamente'
        }, status: :ok
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation, :name)
      end
    end
  end
end
