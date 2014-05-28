shared_examples 'require sign in' do
  it 'redirects to home path with unauthenticated user' do
    clear_user
    action
    expect(response).to redirect_to(sign_in_path)
  end
end
