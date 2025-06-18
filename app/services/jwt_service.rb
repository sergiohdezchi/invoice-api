class JwtService
  SECRET_KEY = Rails.application.secret_key_base.freeze
  API_CLIENTS = Rails.application.credentials.api_clients.with_indifferent_access.freeze

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def self.generate_token(client_id, api_key)
    return nil unless API_CLIENTS[client_id] && API_CLIENTS[client_id] == api_key

    encode({
      client_id: client_id,
      authorized: true
    })
  end

  def self.authorized_client?(token)
    decoded = decode(token)
    decoded && decoded[:authorized] && API_CLIENTS.key?(decoded[:client_id])
  end
end
