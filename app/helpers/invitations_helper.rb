module InvitationsHelper

	def find_us_squash_profile
		search_url = "http://modules.ussquash.com/ssm/pages/SearchDB.asp?wmode=transparent&program=player&name="+@current_user.firstname+"%20"+@current_user.lastname
		doc = Nokogiri::HTML(open(search_url))
		response_links = doc.css("a").select{|link| link.text.match(/#{@current_user.lastname}\b\W+#{@current_user.firstname}/)}
		if response_links.count > 1
			"multiple results"
		else
		link = response_links.first
		index = link['href'].index("Player_profile.asp?id=")
		link['href'][(index+22)..-1].partition("\">")[0]
		end
	end

	def get_last_us_squash_opponent
		reg = /[a-zA-Z]+,[a-zA-Z]+\b/
		new_url = "http://modules.ussquash.com/ssm/pages/Player_profile.asp?id="+@us_squash_id.to_s
		new_doc = Nokogiri::HTML(open(new_url))
		@link_names = new_doc.css("a").select{|link| link.text.match(reg)}
		print @link_names.map{|link| link.text}
		if @link_names.blank?
		else
			link = @link_names.first
			@link_path = "http://modules.ussquash.com/ssm/pages/serve.asp?myurl=modules.ussquash.com/ssm/pages/"+link['href']
			@link_text = link.text
		end
	end
end
