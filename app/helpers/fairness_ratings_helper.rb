module FairnessRatingsHelper

	def fairness_rating_explain(i)
		case i
		when 5
			'Fair in victory and defeat.
			 Pointed out own fouls and where needed argued points cordially.'
		when 4
			'Overall pleasant experience.
			 Argued points where necessary but always cordially.'
		when 3
			'Good experience.
			 Pointed out your fouls more than their own.'
		when 2
			'Taciturn player.
			 Refused to acknowledge own fouls.'
		when 1
			"Should not be on #{APP_NAME}.
			 Rude, dishonest player."
		else
		end
	end
end
