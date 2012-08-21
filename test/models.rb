class Dummy < ActiveRecord::Base
  def self.filtered
    where(kind: 1)
  end
end
