require 'spec_helper'

describe ForgotPasswordController do
  describe 'POST create' do
    context 'with blank input' do
      before { post :create, email: '' }
      it 'redirects to forgot password page' do
        expect(response).to redirect_to(forgot_password_path)
      end
      it 'sets error flash' do
        expect(flash[:error]).to eq('Email cannot be blank')
      end
    end
    context 'with existing email' do
      let(:user) { Fabricate(:user) }
      before { post :create, email: user.email }
      it 'redirects to the forgot password confirmation page' do
        expect(response).to redirect_to(forgot_password_confirmation_path)
      end
      it 'sends email to the email address' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
    end
    context 'without existing email' do
        before { post :create, email: 'not@real.com' }
        it 'redirects to forgot password path' do
          expect(response).to redirect_to(forgot_password_path)
        end
        it 'set error flash' do
          expect(flash[:error]).to eq('No account found')
        end
    end
  end
end
