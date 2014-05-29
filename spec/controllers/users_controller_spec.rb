require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'assigns @user to be new_record' do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of User
    end
  end

  describe 'GET show' do
    let(:user) { Fabricate(:user) }
    before { set_current_user }

    it 'assigns @user' do
      get :show, id: user.id
      expect(assigns(:user)).not_to be_nil
    end

    it_behaves_like('require sign in') do
      let(:action) { get :show, id: user.id }
    end
  end

  describe 'POST create' do
    it 'created new record' do
      post :create, user: Fabricate.attributes_for(:user)
      expect(User.count).to eq(1)
    end
    it 'redirects to sign in path with valid params' do
      post :create, user: Fabricate.attributes_for(:user)
      expect(response).to redirect_to sign_in_path
    end
    it 'renders :new template with invalid params' do
      post :create, user: { full_name: 'John Doe', email: 'john_doe@example.com' }
      expect(response).to render_template :new
    end
    it 'sends welcome email' do
      post :create, user: { full_name: 'John Doe', email: 'john_doe@example.com' }
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end
  end
end
