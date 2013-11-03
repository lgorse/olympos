require 'spec_helper'

describe "Users" do
  before(:all) do
    Capybara.current_driver = :selenium
    fb_login

  end

  describe "GET /sessions/new" do
    it "works! (now write some real specs)", :js => true do
      visit root_path
       expect(page).to have_link("Log out")
      
    end

    it 'visits FB', :js => true do
     
         visit 'http://www.facebook.com/settings?tab=applications'
         within(:css, "li.pam") do
         page.find("a[role=button]").click
         sleep 3
         page.find("a[aria-label='Remove Olympos_test']").click
         within_window(page.driver.browser.window_handles.last) do
       click_button("Remove")
     end
         end

      

    end

  end   

end
