class FriendshipsController < ApplicationController
	

	before_filter :authenticate
	
	def create
		@user = User.find(params[:friendship][:friended_id])
		if @friendship = @current_user.friend(@user)	
		else
		end
	end

	def accept
		@user = User.find(params[:friendship][:friender_id])
		@friendship = @current_user.accept(@user)
	end

	def destroy
		@user = Friendship.find(params[:id]).friended
		@current_user.unfriend(@user)		
	end

	def friendships
		@user = User.find(params[:user_id])
		@friendships = @user.friends
	end

	def requests
		@user = User.find(params[:user_id])
		@friend_requests = @user.friend_requests
	end

	def pending
		@user = User.find(params[:user_id])
		@friends_pending = @user.friends_pending
	end
end
