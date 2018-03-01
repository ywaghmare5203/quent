class AddAttachmentQuestionMediaToQuestions < ActiveRecord::Migration[5.1]
  def self.up
    change_table :questions do |t|
      t.attachment :question_media
    end
  end

  def self.down
    remove_attachment :questions, :question_media
  end
end
