Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-1.amazonaws.com'

Paperclip.interpolates('gender') do |attachment, style|
	gender = attachment.instance.gender
	gender == MALE ? "male".parameterize : "female".parameterize
	end