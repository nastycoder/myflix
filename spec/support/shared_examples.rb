shared_examples 'require sign in' do
  it 'redirects to home path with unauthenticated user' do
    clear_current_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples 'token generator' do
  it 'generates a random token' do
    expect(model.token).not_to be_nil
  end
end

shared_examples 'ensure admin' do
  it_behaves_like('require sign in')
  it 'redirects to home path when user is not admin' do
    action
    expect(response).to redirect_to(home_path)
  end
end
