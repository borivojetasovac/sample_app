class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token         # Creates getter and setter methods.
  before_save   :downcase_email                            # This callback (method reference) is automatically called before the object is saved (created and updated).
  before_create :create_activation_digest                  # This callback is automatically called before the object is created.
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token (from cookie) matches the digest (from User object).
  def authenticated?(remember_token)
    return false if remember_digest.nil?            # Multiple browsers (with remembered users); if user logs out in one browser, an error would occur in another:
    BCrypt::Password.new(remember_digest).is_password?(remember_token)                                        # remember_digest would be nil
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
