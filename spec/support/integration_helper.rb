module IntegrationHelper

	def fb_login
    # @test_users = Koala::Facebook::TestUsers.new(:app_id => FACEBOOK_CONFIG['app_id'], :secret => FACEBOOK_CONFIG['app_secret'])
    # fb_user = @test_users.list.first
    # print fb_user
    # @user = FactoryGirl.create(:user,  :fb_id => fb_user["id"], :signup_method => FACEBOOK)
    # get fb_user['login_url']
    # sleep 5
    # visit root_path
    # click_link("fb_signup")
  #     sleep 1
  #     within_window(page.driver.browser.window_handles.last) do
  #      fill_in 'email', :with => "lgorse@mac.com"
  #      fill_in 'pass', :with => "martybear"
  #      click_button 'Log In'
  #    end
	end

  def email_login
    visit root_path
    fill_in 'session_email', :with => @user.email
    fill_in 'session_password', :with => @user.password
    click_button 'Log in'

  end

  def signup_success
    visit root_path
        page.find("a[href='/users/new']").click
        fill_in 'user_firstname', :with => "Tester"
        fill_in 'user_lastname', :with => "Testaroo"
        fill_in 'user_email', :with => "test@test.com"
        fill_in 'user_password', :with => "testpassword"
        select '1979', :from => 'user_birthdate_1i'
        choose 'user_gender_1'
        click_button 'Sign up'
  end


end