require 'spec_helper'

describe MatchesController do

	describe "GET New" do

		describe "authentication" do
			before(:each) do
				@user = FactoryGirl.create(:user)
			end

			describe "if successful" do

				it 'should be successful' do
					test_sign_in(@user)
					get :new
					response.should be_successful
				end

				
			end

			describe 'if failed' do

				it "should redirect ot the root path" do
					get :new
					response.should redirect_to root_path
				end

			end

		end

	end

end
