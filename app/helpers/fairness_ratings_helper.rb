module FairnessRatingsHelper

	def rating_explain(i)
		case i
		when 5
			'Your opponent was cordial and fair in every interaction. </b>
			When there was a disagreement, he argued thoughfully.</b>
			He was gracious in victory and defeat.'
		when 4
			'Your opponent was cordial and fair in every interaction. 
			He called out your fouls more often than he acknowledged yours.
			He was gracious in victory and defeat.'
		when 3
			'Your opponent was sometimes brusque and did not attempt to make you at ease.
			He called out your fouls more often than he acknowledged yours.
			He was gracious in victory and defeat.'
		when 2
			'Your opponent was rude or taciturn
			He was unfair in managing fouls.
			He was frustrated in defeat'
		when 1
			'Your opponent was rude.
			He became aggressive when discussing fouls.
			He was rude or mocking in victory and defeat'
		else
		end
	end
end
