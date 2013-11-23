module UsersHelper

	def save_manual_user
		if @current_user.save
			new_user_success
		else
			render 'new'
		end
	end

	def new_user_from_FB
		my_fb = @graph.get_object("me")
		@attr = {:firstname => my_fb['first_name'], :lastname => my_fb['last_name'],
			:email => my_fb['email'], :gender => my_fb['gender'],
			:birthdate => Date.strptime(my_fb['birthday'], "%m/%d/%Y"), :fb_id => my_fb['id'],
			:password => 'randompassword'}
			@current_user = User.where(:fb_id => @signed_request['user_id']).first_or_initialize(@attr.merge(:signup_method => FACEBOOK))
			save_fb_user
		end

		def save_fb_user
			if @current_user.save
				new_user_success
			else
				render 'fb'
			end
		end


		def new_user_success
			sign_in_user
			redirect_to details_user_path(@current_user)
		end

		def current_user?(user)
			user == @current_user
		end

		def recommended_players(zip, country, distance)
			if zip && country
				coordinates = Geocoder.coordinates("#{zip} #{country}")
				@lat = coordinates.first
				@long = coordinates.last
				if distance
					User.near([@lat, @long], distance).without_user(@current_user)
				else
					User.near([@lat, @long], 20).without_user(@current_user)
				end
			elsif (@current_user.lat.blank? || @current_user.long.blank?)	
				if request.blank?
					render 'users/search'
				else
					@lat = request.location.latitude
					@long = request.location.longitude
					User.near([@lat, @long], 20).without_user(@current_user)
				end
			else 
			@lat = @current_user.lat
			@long = @current_user.long	
				if distance
					@current_user.nearbys(distance)
				else
					@current_user.nearbys(10)
				end
			end

		end

	end
