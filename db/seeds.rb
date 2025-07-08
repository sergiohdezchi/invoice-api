# This file creates default users for development and testing

# Crear usuario administrador
admin_user = User.find_or_initialize_by(email: 'admin@example.com')
admin_user.update!(
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Administrador',
  active: true
)
puts "Usuario admin creado: #{admin_user.email}"

# Crear usuario regular
user = User.find_or_initialize_by(email: 'user@example.com')
user.update!(
  password: 'password123',
  password_confirmation: 'password123',
  name: 'Usuario Regular',
  active: true
)
puts "Usuario regular creado: #{user.email}"
