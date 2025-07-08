class UserSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :email, :name, :active, :created_at
end
