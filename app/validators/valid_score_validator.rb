class ValidScoreValidator < ActiveModel::EachValidator

	def validate_each(record, attribute, value)
		unless value.blank?
			value.each do |score|
				record.errors[attribute] << " must consist of numbers only" unless score.is_a? Integer
			end
		end
	end
end