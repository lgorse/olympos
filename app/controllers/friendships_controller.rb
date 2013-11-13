class FriendshipsController < ApplicationController
	

	before_filter :authenticate

	def create
		@friendship = Friendship.new(params[:friendship])
		if @friendship.save
			
		else
		end
	end

	def destroy
		@user = Friendship.find(params[:id]).friended
		@current_user.unfriend(@user)		
	end

	def friendships
		@user = User.find(params[:user_id])
		@friendships = @user.friendships
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
