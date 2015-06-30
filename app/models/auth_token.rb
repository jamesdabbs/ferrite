class AuthToken < ActiveRecord::Base
  belongs_to :user

  validates :key, presence: true, length: { in: 32..255 }, uniqueness: true
  validates_presence_of :user

  after_initialize { generate_key unless key }

  def expire!
    update! expires_at: Time.now
  end
  def expired?
    expires_at && expires_at < Time.now
  end
  def active?
    !expired?
  end

private

  def generate_key
    begin
      self.key ||= SecureRandom.uuid
    end while self.class.exists?(key: key)
  end
end
