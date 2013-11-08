require 'spec_helper'

describe "Users" do

  describe "user login" do
    # before(:all) do
    #   Capybara.current_driver = :selenium
    #   fb_login
    # end

  end


  describe "user CREATE" do

    describe "if successful" do

      describe "successful login" do

      it "should add a user" do
        lambda do
          signup_success
        end.should change(User, :count).by(1)

      end

    end

      describe "details redirect" do
        before(:all) do
          signup_success
        end


        it "should show details" do 
        @user = assigns[:current_user]
          current_path.should == "/users/#{@user.id}/details"
          #expect(page).to have_css('h1')
          #expect(page).to have_link('Olympos')
        end

        it "should show the user rating input" do
          expect(page).to have_css('#user_first_rating')
        end

        it "should show the user zip input" do
          expect(page).to have_css('#user_zip')
        end

      end



    end

    

  end

  describe "GET /Users/home" do

    describe "if user is logged through email" do
      before(:each) do
        @user = FactoryGirl.create(:user, :signup_method => EMAIL)
        email_login
      end


      it "should show a picture connected to the user.photo method" do
        page.find("a[href='/users/#{@user.id}']").click
        expect(page).to have_css(".custom")
      end

    end

    # describe "if user is logged through Facebook" do

    #   before(:all) do
    #   Capybara.current_driver = :selenium
    #   fb_login
    # end

    #   it "should show a Facebook picture" do
    #     page.find("a[href='/users/#{@user.id}']").click
    #     expect(page).to have_css(".fb")

    #   end

    # end

  end

  
end



   #  describe "GET /" do
 #    it "redirects the user to his home page", :js => true do
 #      #current_path.should == "users/#{assigns(:current_user)}/home"
 #    end


 #   #  it 'visits FB', :js => true do

 #   #   visit 'http://www.facebook.com/settings?tab=applications'
 #   #   within(:css, "li.pam") do
 #   #     page.find("a[role=button]").click
 #   #     sleep 3
 #   #     page.find("a[aria-label='Remove Olympos_test']").click
 #   #     within_window(page.driver.browser.window_handles.last) do
 #   #       click_button("Remove")
 #   #     end
 #   #   end
 #   # end

 # end  