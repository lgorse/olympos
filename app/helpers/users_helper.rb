module UsersHelper

	def save_manual_user
		if @user.save
			save_user_success
		else
			render 'new'
		end
	end

	def save_fb_user
		if @user.save
			@access_token = @signed_request['access_token']
			save_user_success
		else
			render 'fb'
		end
	end

	def save_user_success
		sign_in_user(@user)
		redirect_to details_user_path(@user)
	end
end
