class AddQuestionsRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :users, foreign_key: true
  end
end
