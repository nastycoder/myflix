require 'spec_helper'

describe PagesController do
  describe '#front' do
    it 'redirects to home path with authenticated user' do
      session[:user] = Fabricate(:user).id
      get :front
      expect(response).to redirect_to(home_path)
    end
  end
end
