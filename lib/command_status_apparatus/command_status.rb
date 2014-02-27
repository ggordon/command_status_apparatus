class CommandStatus < ActiveRecord::Base

  validates :key, :presence => true

  scope :ordered, -> { order("updated_at DESC") }

  def self.last_status(key)
    where(key: key).limit(1).ordered
  end

  def self.keys
    select("distinct(command_statuses.key)").map(&:key)
  end

  def update_status
    self.status = if success_count == total_count
                    'OK'
                  elsif success_count == 0
                    'FAIL'
                  else
                    'PARTIAL'
                  end
  end
end




