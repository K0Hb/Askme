class Question < ApplicationRecord
  def hidden?
    self.hidden
  end
end
