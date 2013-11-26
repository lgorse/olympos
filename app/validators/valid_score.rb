class ValidScore < ActiveModel::Validator

	def validate(record)
		win_count = []
		record.errors[:base] << "must have the same number of periods" unless (record.player1_score.count == record.player2_score.count)
		validate_each_score(record, win_count)
		validate_period_structure(record, win_count)
	end

	def validate_each_score(record, win_count)
		record.player1_score.count.times do |i|
			score1 = record.player1_score[i]
			score2 = record.player2_score[i]
			if [score1, score2].all?{|score| score.is_a? Integer}
				if [score1, score2].any?{|score| score > WINNING_SCORE}
					record.errors[:base] << "must have a 2-point difference if scoring went beyond #{WINNING_SCORE}" if ((score1 - score2).abs != 2)
				elsif [score1, score2].all?{|score| score < WINNING_SCORE}
					record.errors[:base] << "must have a winning score"
				end
				record.errors[:base] << "has already won" if [win_count.count(1), win_count.count(2)].any?{|win| win == MAX_PERIODS_TO_WIN}
				score1 > score2 ? win_count.push(1) : win_count.push(2)  
			else
				record.errors[:base] << " must consist of numbers only"
			end
		end
	end

	def validate_period_structure(record, win_count)
		record.errors[:base] << "must be over the regulation number of sets" if [win_count.count(1), win_count.count(2)].all?{|win| win != MAX_PERIODS_TO_WIN}
		record.errors[:base] << "can only have a maximum of #{MAX_PERIODS} sets" if win_count.count > 5
	end
end