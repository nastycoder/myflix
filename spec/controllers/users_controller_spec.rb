require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'assigns @user to be new_record' do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of User
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
  end
end
