require "spec_helper"

describe AppMailer do
  describe '#welcome_user' do
    let(:user) { Fabricate(:user) }
    let(:mail) { AppMailer.welcome_user(user) }
    it 'sets the subject' do
      expect(mail.subject).to eql('Welcome to MyFlix')
    end
    it 'sets the to email address' do
      expect(mail.to).to eq([user.email])
    end
    it 'sets the from email address' do
      expect(mail.from).to eq(['noreply@myflix.com'])
    end
    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.full_name)
    end
  end

  describe '#forgot_password' do
    let(:user) { Fabricate(:user) }
    let(:mail) { AppMailer.forgot_password(user) }

    it 'sets the subject' do
      expect(mail.subject).to eql("Seems you've forgotten your password")
    end
    it 'sets the from email address' do
      expect(mail.from).to eq(['noreply@myflix.com'])
    end
    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.full_name)
    end
  end
end
