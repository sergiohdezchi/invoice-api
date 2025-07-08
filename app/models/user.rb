class User < ApplicationRecord
  # Include only necessary devise modules for API
  devise :database_authenticatable, :registerable, :validatable
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  
  # Método para actualizar la contraseña verificando la contraseña actual
  def update_with_password(params)
    current_password = params.delete(:current_password)
    
    if valid_password?(current_password)
      update(params)
    else
      errors.add(:current_password, "es incorrecta")
      false
    end
  end
end
