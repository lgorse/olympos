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
				if distance
					User.near(Geocoder.coordinates("#{zip} #{country}"), distance)
				else
					User.near(Geocoder.coordinates("#{zip} #{country}"), 20)
				end
			elsif (@current_user.lat.blank? || @current_user.long.blank?)	
				if request.blank?
					render 'users/search'
				else
					User.near([request.location.latitude, request.location.longitude], 20)
				end
			else 	
				if distance
					@current_user.nearbys(distance)
				else
					@current_user.nearbys(10)
				end
			end

		end

	end
