class LoggedRunner

  class LoggedRunnerBlockRequiredException < Exception; end

  attr_reader :key
  attr_reader :method
  attr_reader :args
  attr_reader :cs
  attr_reader :success_count
  attr_reader :pbar

  def initialize(key, method, args=nil)
    @key           = key
    @method        = method
    @args          = args
    @success_count = 0
  end

  def self.run(key, method, *args, &blk)
    lr = LoggedRunner.new(key, method, args)
    lr.run(&blk)
    lr
  end

  def run(&blk)
    raise LoggedRunnerBlockRequiredException unless blk
    begin
      @cs = CommandStatus.create(key: key)
      cs.success_count = 0
      run_list blk.call
      cs.update_status
    ensure
      cs.save
    end
  end

  private

  def run_list(list)
    case list
    when CommandStatusInterface
      cs.total_count = 100
      initialize_pbar
      list.initialize_command_status(cs, pbar)
      run_item(list)
      cs.success_count -= 1 # need to correct for the overcount
    when Array
      cs.total_count = list.size
      initialize_pbar
      while item = list.shift do
        run_item(item)
        pbar.increment  if pbar
      end
    when ActiveRecord::Relation
      cs.total_count = list.count
      initialize_pbar
      list.find_each do |list_item|
        run_item(list_item)
        pbar.increment  if pbar
      end
    else
      cs.total_count = 1
      initialize_pbar
      run_item(list)
      cs.success_count = 1
    end
    pbar.finish  if pbar
  end

  def initialize_pbar
    if STDERR.tty? && !Rails.env.test?
      @pbar = ProgressBar.create(format: '%e |%b>>%i| %p%% %t', title: key, total: cs.total_count)
    end
  end

  def run_item(item)
    begin
      if args.present?
        item.send(method, *args)
      else
        item.send(method)
      end
    rescue Exception => e
      cs.message = e.message
      cs.failed_instance = item.to_s
    else
      cs.success_count += 1
    end
  end

end

