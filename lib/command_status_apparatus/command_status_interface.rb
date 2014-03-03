module CommandStatusInterface

  def initialize_command_status(cs, pbar)
    @command_status_instance = cs
    @command_status_progress_bar = pbar
  end

  def call_with_command_status_logging(count)
    @command_status_instance.total_count = count if @command_status_instance
    @command_status_progress_bar.total = count if @command_status_instance
    result = yield
    @command_status_instance.success_count = @command_status_success_count if @command_status_instance
    result
  end

  def increment_command_status_progress
    result = yield
    @command_status_progress_bar.try(:increment) if @command_status_instance
    @command_status_success_count ||= 0 if @command_status_instance
    @command_status_success_count += 1 if result.present? if @command_status_instance
    result
  end

end
