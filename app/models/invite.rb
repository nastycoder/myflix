require 'tokenable'

class Invite < ActiveRecord::Base
  include Tokenable

  belongs_to :user

  after_create :send_invitation

  validates_presence_of :name, :email, :message, :user

  def accepted_by(invited_user)
    invited_user.follow(self.user)
    self.user.follow(invited_user)
    expire_token
  end

  private
    def expire_token
      self.token = nil
      self.save
    end
    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end

    def send_invitation
      AppMailer.invitation(self).deliver
    end
end
