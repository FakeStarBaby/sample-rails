def page_path(page_name)
  case page_name
  when 'ユーザー一覧'
    users_path
  when 'ユーザー詳細'
    user_path(@user)
  when 'ユーザー作成'
    new_user_path
  when 'ユーザー編集'
    edit_user_path(@user)
  end
end

step 'ユーザーが登録されている' do
  @user = create(:user)
end

step '複数ユーザーが登録されている' do
  @users = create_list(:user, 5)
end

step ":page_name ページにアクセスする" do |page_name|
  visit page_path(page_name)
end

step ':page_name ページが表示される' do |page_name|
  expect(current_path).to eq(page_path(page_name))
end
