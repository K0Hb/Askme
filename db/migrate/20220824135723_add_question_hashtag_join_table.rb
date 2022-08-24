class AddQuestionHashtagJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :questions, :hashtags do |t|
      t.index [:hashtag_id, :question_id], unique: true
    end
  end
end
