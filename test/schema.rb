ActiveRecord::Schema.define :version => 0 do
  create_table "command_statuses", :force => true do |t|
    t.string   "key",             :limit => 100
    t.string   "status",          :limit => 50
    t.integer  "total_count"
    t.integer  "success_count"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "failed_instance"
  end
end
