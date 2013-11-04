namespace :rspec do
	task :features do
		system "rspec ./spec/features/users_spec.rb"
	end

end