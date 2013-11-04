require 'spec_helper'

describe "Users" do
 
describe "user login" do
   before(:all) do
    Capybara.current_driver = :selenium
    fb_login
  end
 
 describe "GET /" do
    it "redirects the user to his home page", :js => true do
      #current_path.should == "users/#{assigns(:current_user)}/home"
    end

    
   #  it 'visits FB', :js => true do

   #   visit 'http://www.facebook.com/settings?tab=applications'
   #   within(:css, "li.pam") do
   #     page.find("a[role=button]").click
   #     sleep 3
   #     page.find("a[aria-label='Remove Olympos_test']").click
   #     within_window(page.driver.browser.window_handles.last) do
   #       click_button("Remove")
   #     end
   #   end
   # end

  end  

  describe "GET /users/details" do

    it "should feature the user image" do
      

    end

  end

  describe "GET /Users/home" do

    it "should feature the user image" do

    end

  end

end

end