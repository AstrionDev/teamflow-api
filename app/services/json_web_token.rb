class JsonWebToken
  class DecodeError < StandardError; end

  ALGORITHM = "HS256".freeze

  def self.encode(payload, exp: 24.hours.from_now)
    payload = payload.merge("exp" => exp.to_i)
    JWT.encode(payload, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded, = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    decoded
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    raise DecodeError, e.message
  end

  def self.secret_key
    Rails.application.credentials.jwt_secret || ENV.fetch("JWT_SECRET", nil) || Rails.application.secret_key_base
  end
end
