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


end