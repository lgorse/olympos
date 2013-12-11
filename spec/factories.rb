FactoryGirl.define do
	factory :user do
		firstname 	"test"
		lastname	"tester"
		email		{generate(:email)}
		password	"Supercool"
		birthdate	15.years.ago.to_date.year
		gender		MALE
		zip 		94303
		country 	"US"
	end
end

FactoryGirl.define do
	sequence :email do |n|
		"tester#{n}@test.com"
	end
end

FactoryGirl.define do
	factory :invitation do
		association :inviter, factory: :user

		factory :email_invitation, parent: :invitation do
			email 	{generate(:email)}
			invite_method	EMAIL
		end

		factory :fb_invitation do
			fb_id 	2
			invite_method	FACEBOOK
		end
	end

end

FactoryGirl.define do
	factory :friendship do
		association :friender, factory: :user
		association :friended, factory: :user
	end
end

FactoryGirl.define do
	factory :club do
		name	"test_club"
		zip 	9403
		country	"US"
	end

end

FactoryGirl.define do
	factory :match do
		association :player1, factory: :user
		association :player2, factory: :user
		player1_score	[11, 11, 11]
		player2_score 	[9, 9, 0]
		winner_id	{player1_id}
		play_date 	1.day.ago.to_date
	end

end

FactoryGirl.define do
	factory :fairness_rating do
		association :match, factory: :match
		association :rater, factory: :user
		association :rated, factory: :user
		rating 	4
	end

end



