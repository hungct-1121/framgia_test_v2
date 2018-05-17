class User < ActiveRecord::Base
  include RailsAdminUser

  devise :database_authenticatable, :registerable,
    :rememberable, :trackable, :validatable, :recoverable, :omniauthable

  has_many :exams, dependent: :destroy
  has_many :questions

  class << self
    def generate_unique_secure_token
      loop do
        random_token = SecureRandom.urlsafe_base64
        break random_token unless User.exists? encrypted_password: BCrypt::Password.create(random_token)
      end
    end

    def from_omniauth auth
      user = find_or_initialize_by(email: auth.info.email).tap do |u|
        u.name = auth.info.name
        u.password = User.generate_unique_secure_token if u.new_record?
        u.provider = auth.provider
        u.token = auth.credentials.token
        u.refresh_token = auth.credentials.refresh_token
        u.save!
      end
      user
    end
  end
end
