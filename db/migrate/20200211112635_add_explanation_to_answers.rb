class AddExplanationToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :explanation, :text
  end
end
