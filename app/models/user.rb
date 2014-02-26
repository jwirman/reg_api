class User < ActiveRecord::Base
  include ActiveModel::Validations

  before_save :generate_auth_token

  attr_accessor :password_confirmation

  validates :name, :password, :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validate :password_equal_password_confirmation

  def password_equal_password_confirmation
    unless password == password_confirmation
      errors.add(:password, 'does not match password confirmation')
    end
  end

  def as_json(options={})
    { id: id, name: name, email: email, authentication_token: authentication_token }
  end

  private
    def generate_auth_token
      self.authentication_token = SecureRandom.hex
    end

end
