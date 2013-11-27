class CommandStatus < ActiveRecord::Base

  validates :key, :presence => true

  scope :ordered, -> { order("updated_at DESC") }

  def self.last_status(key)
    where(key: key).limit(1).ordered
  end

  def self.keys
    select("distinct(command_statuses.key)").map(&:key)
  end

end




