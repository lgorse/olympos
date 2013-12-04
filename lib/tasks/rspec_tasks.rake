namespace :rspec do
	task :features do
		system "rspec ./spec/features/users_spec.rb"
	end

end

task :beautify do
	@files = Dir.glob("app/views/**/*.erb")
	@files.each do |file|
		system 'htmlbeautifier '+file
	end
	#@files.map{|file| puts file}
end