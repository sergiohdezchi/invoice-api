class TokenGeneratorService
  SECRET_KEY = Rails.application.secret_key_base

  def initialize(user)
    @user = user
  end

  def generate_token(expiration = 24.hours.from_now)
    payload = {
      user_id: @user.id,
      exp: expiration.to_i,
      iat: Time.now.to_i
    }

    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
