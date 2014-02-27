module CommandStatusInterface

  def initialize_command_status(cs, pbar)
    @command_status_instance = cs
    @command_status_progress_bar = pbar
  end

  def call_with_command_status_logging(count)
    @command_status_instance.total_count = count
    @command_status_progress_bar.total = count
    result = yield
    @command_status_instance.success_count = @command_status_success_count
    result
  end

  def increment_command_status_progress
    result = yield
    @command_status_progress_bar.try(:increment)
    @command_status_success_count ||= 0
    @command_status_success_count += 1 if result.present?
    result
  end

end
