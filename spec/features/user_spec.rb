require 'spec_helper'

describe 'ユーザー管理' do
  describe 'ユーザー一覧' do
    let!(:users) { create_list(:user, 5) }
    before do
      visit users_path
    end

    it 'ユーザー一覧ページが表示される' do
      expect(current_path).to eq(users_path)
    end

    it '複数ユーザーのデータが表示される' do
      users.each do |user|
        expect(page).to have_content(user.name)
      end
    end
  end

  describe 'ユーザー詳細' do
    let(:user) { create(:user) }
    before do
      visit user_path(user)
    end

    it 'ユーザー詳細ページが表示される' do
      expect(current_path).to eq(user_path(user))
    end

    it 'ユーザーのデータが表示される' do
      expect(page).to have_content(user.name)
    end
  end

  describe 'ユーザー作成' do
    before do
      visit new_user_path
    end

    it 'ユーザー作成ページが表示される' do
      expect(current_path).to eq(new_user_path)
    end

    context '名前を入力する' do
      let(:name) { Faker::Name.name }
      before do
        within("form[action='#{users_path}']") do
          find('#user_name').set(name)
        end
      end

      context 'アクションボタンを押下する' do
        let(:user) { User.last }
        before do
          within("form[action='#{users_path}']") do
            find('input[name=commit]').click
          end
        end

        it 'ユーザーが作成される' do
          expect(user.name).to eq(name)
        end

        it 'ユーザー詳細ページが表示される' do
          expect(current_path).to eq(user_path(user))
        end
      end
    end
  end

  describe 'ユーザー更新' do
    let!(:user) { create(:user) }
    before do
      visit edit_user_path(user)
    end

    it 'ユーザー更新ページが表示される' do
      expect(current_path).to eq(edit_user_path(user))
    end

    context '名前を変更する' do
      let(:name) { Faker::Name.name }
      before do
        within("form[action='#{user_path(user)}']") do
          find('#user_name').set(name)
        end
      end

      context 'アクションボタンを押下する' do
        before do
          within("form[action='#{user_path(user)}']") do
            find('input[name=commit]').click
          end
        end

        it 'ユーザーのデータが更新される' do
          user.reload
          expect(user.name).to eq(name)
        end

        it 'ユーザー詳細ページが表示される' do
          expect(current_path).to eq(user_path(user))
        end
      end
    end
  end

  describe 'ユーザー削除' do
    let!(:users) { create_list(:user, 5) }
    let(:delete_user) { User.first }
    before do
      visit users_path
    end

    it 'ユーザー一覧ページが表示される' do
      expect(current_path).to eq(users_path)
    end

    it '削除するユーザーのデータが表示される' do
      expect(page).to have_content(delete_user.name)
    end

    context '削除ボタンを押下する' do
      before do
        find("a[data-method='delete'][href='#{user_path(delete_user)}']").click
      end

      context '表示された確認ダイアログにて、OK ボタンを押下する' do
        it '削除されたユーザーのデータが表示されない' do
          expect(page).not_to have_content(delete_user.name)
        end
      end
    end
  end
end
