class Action < ActiveRecord::Base
  def self.inheritance_column
    nil
  end
  
  def action_type
    read_attribute :type
  end
  
  def file_path
    file_path = self.current_file_path
    unless file_path
      a = Action.where("file_id = ? AND commit_id < ?", self.file_id, self.commit_id).order("commit_id DESC").limit(1)
      unless a.empty?
        file_path = a[0].current_file_path
        self.current_file_path = file_path
        self.save!
      end
    end
    file_path
  end
end
