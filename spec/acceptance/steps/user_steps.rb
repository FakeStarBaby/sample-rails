steps_for :user do
  step '名前を入力する' do
    @name = Faker::Name.name
    within("form[action='#{users_path}']") do
      find('#user_name').set(@name)
    end
  end

  step '名前を変更する' do
    @name = Faker::Name.name
    within("form[action='#{user_path(@user)}']") do
      find('#user_name').set(@name)
    end
  end

  step '登録ボタンを押下する' do
    within("form[action='#{users_path}']") do
      find('input[name=commit]').click
    end
    @user = User.last
  end

  step '更新ボタンを押下する' do
    within("form[action='#{user_path(@user)}']") do
      find('input[name=commit]').click
    end
    @user.reload
  end

  step '削除ボタンを押下する' do
    find("a[data-method='delete'][href='#{user_path(@user)}']").click
  end

  step 'ユーザーのデータが表示される' do
    expect(page).to have_content(@name)
  end

  step '更新されたユーザーのデータが表示される' do
    expect(page).to have_content(@name)
  end

  step '複数ユーザーのデータが表示される' do
    @users.each do |user|
      expect(page).to have_content(user.name)
    end
  end

  step '削除するユーザーのデータが表示される' do
    expect(page).to have_content(@user.name)
  end

  step '削除されたユーザーのデータが表示されない' do
    expect(page).not_to have_content(@user.name)
  end
end
