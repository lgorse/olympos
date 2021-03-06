class FriendshipsController < ApplicationController
	

	before_filter :authenticate
	
	def create
		@user = User.find(params[:friendship][:friended_id])
		@friendship = @current_user.friend(@user)	
	end

	def accept
		@user = User.find(params[:friendship][:friender_id])
		@friendship = @current_user.accept(@user)
	end

	def destroy
		@user = Friendship.find(params[:id]).friended
		@current_user.unfriend(@user)		
	end

	def reject
		@user = Friendship.find(params[:id]).friender
		@user.unfriend(@current_user)
	end

	def friendships
		@user = User.find(params[:user_id])
		friend_hash = []
		@friendships = @user.friends.each do |friend|
			friend_hash.push({:name => friend.fullname, :id => friend.id})
			friend
		end
		
		respond_to do |format| 
			format.js {}
			format.json {render :json => friend_hash}
		end
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
