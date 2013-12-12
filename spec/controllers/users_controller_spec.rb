require 'spec_helper'

describe UsersController do


  describe 'GET "new"' do

  end

  describe 'POST "create" BY EMAIL' do
    before(:each) do
      @attr = {:firstname => "test", :lastname => "tester",
               :email => "test@test.com", :password => "gobbledygook",
               :birthdate => 14.years.ago.to_date, :gender => MALE}
    end

    describe 'if successful' do


      it "should create a new user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the details page" do
        post :create, :user => @attr
        response.should redirect_to details_user_path(assigns(:current_user))
      end

      it "should create a session" do
        post :create, :user => @attr
        session[:user_id].should == assigns(:current_user).id
      end
    end

    describe 'if failed' do

      it "should render a new page" do
        post :create, :user => @attr.merge(:firstname => '')
        response.should render_template('new')

      end

      it "should show the error" do
        post :create, :user => @attr.merge(:firstname => '')

      end

      it "should not create a new user" do
        lambda do
          post :create, :user => @attr.merge(:firstname => '')
        end.should_not change(User, :count)

      end

    end

  end


  describe 'PUT "Update"' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe 'if successful' do
      before(:each) do
        @attr = {:zip => 94305}
      end

      it "should update the user\'s attributes" do
        put :update, :id => @user.id, :user => @attr
        User.find(@user).zip.should == @attr[:zip]
      end


      it "should redirect to the address in the redirect_url" do
        put :update, :id => @user.id, :user => @attr, :redirect_url => details_user_path(@user.id)
        response.should redirect_to details_user_path(@user.id)
      end




    end

    describe 'if failed' do


    end

  end

  describe "GET 'details'" do

    describe "authentication" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      describe "if successful" do

        it 'should be successful' do
          test_sign_in(@user)
          get :details, :id => @user.id
          response.should be_successful
        end

      end

      describe 'if failed' do

        it "should redirect to root" do
          get :details, :id => @user.id
          response.should redirect_to root_path

        end

      end

    end


  end

  describe "GET 'home' geolocalization test" do
    before(:each) do
      @user = FactoryGirl.create(:user, :zip => '')
    end

    it "should geolocalize the user" do
      test_sign_in(@user)
      get :home, :id => @user
      user = User.find(@user.id)
      user.lat.should_not be_blank
      user.long.should_not be_blank
      user.zip.should_not be_blank
      
    end

  end

  describe "GET 'home'" do

    describe "authentication" do
      before(:each) do
        @user = FactoryGirl.create(:user)

      end

      describe "if successful" do

        it 'should be successful' do
          test_sign_in(@user)
          get :home, :id => @user
          response.should be_successful
        end

      end

      describe 'if failed' do

        it "should redirect to root" do
          get :home, :id => @user
          response.should redirect_to root_path

        end

      end

    end

  end

  describe "GET 'edit'" do


    describe "authentication" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      describe "if successful" do

        it 'should be successful' do
          test_sign_in(@user)
          get :edit, :id => @user
          response.should be_successful
        end




      end

      describe 'if failed' do

        it "should redirect to root" do
          get :edit, :id => @user
          response.should redirect_to root_path

        end

      end

    end

  end

  describe "DELETE 'destroy'" do
    describe "authentication" do
      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      describe "if successful" do

        it 'should destroy the user' do
          test_sign_in(@user)
          lambda do
            delete :destroy, :id => @user
          end.should change(User, :count).by(-1)
        end




      end

      describe 'if failed' do

        it "should not destroy the user" do
          lambda do
            delete :destroy, :id => @user
          end.should_not change(User, :count)
        end

      end

    end

    describe 'redirect' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end

      it 'should redirect to the root path' do
        delete :destroy, :id => @user.id
        response.should redirect_to root_path

      end

    end

  end

  describe "GET 'map'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      3.times {|i| FactoryGirl.create(:user, :zip => "9430#{i}")}
      @user_list = User.without_user(@user).pluck(:id)
      test_sign_in(@user)
    end

    describe "general function"  do

      it "should not include the user" do
        get :map, :users => @user_list
        assigns(:user_select).should_not include(@user)
      end

    end



    it "should return the search results according to the params" do
      get :map, :users => @user_list
      assigns(:user_select).map{|user| user.id}.should == @user_list
    end


  end


end
