module Api
  module V1
    class ProfileController < ApplicationController
      # GET /api/v1/profile
      def show
        render json: UserSerializer.new(current_user).serializable_hash
      end
      
      # PUT /api/v1/profile
      def update
        if current_user.update(profile_params)
          render json: {
            status: 'success',
            message: 'Perfil actualizado correctamente',
            data: UserSerializer.new(current_user).serializable_hash
          }, status: :ok
        else
          render json: {
            status: 'error',
            message: 'Error al actualizar el perfil',
            errors: current_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      # PUT /api/v1/profile/password
      def update_password
        if current_user.update_with_password(password_params)
          # Generar un nuevo token después de cambiar la contraseña
          token_service = TokenGeneratorService.new(current_user)
          token = token_service.generate_token
          expiration = Time.now + 24.hours
          
          render json: {
            status: 'success',
            message: 'Contraseña actualizada correctamente',
            data: {
              token: token,
              token_type: 'Bearer',
              expires_at: expiration.to_i
            }
          }, status: :ok
        else
          render json: {
            status: 'error',
            message: 'Error al actualizar la contraseña',
            errors: current_user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
      
      private
      
      def profile_params
        params.permit(:name, :email)
      end
      
      def password_params
        params.permit(:current_password, :password, :password_confirmation)
      end
    end
  end
end
