module IntegrationHelper

	def fb_login
		visit root_path
      click_link("fb_signup")
      sleep 1
      within_window(page.driver.browser.window_handles.last) do
       fill_in 'email', :with => "lgorse@mac.com"
       fill_in 'pass', :with => "martybear"
       click_button 'Log In'
     end
	end


end