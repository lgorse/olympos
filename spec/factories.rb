FactoryGirl.define do
	factory :user do
		firstname 	"test"
		lastname	"tester"
		email	{generate(:email)}
		password	"Supercool"
		birthdate	15.years.ago.to_date
		gender	MALE
	end
end

FactoryGirl.define do
	sequence :email do |n|
		"tester#{n}@test.com"
	end
end

