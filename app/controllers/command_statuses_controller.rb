class Admin::CommandStatusesController < ApplicationController
  def index
    keys = CommandStatus.keys.sort
    command_statuses = keys.map { |k| CommandStatus.last_status(k).first }
    @command_statuses = CommandStatusDecorator.decorate(command_statuses)
  end

  def show
    @command_statuses = CommandStatus.last_status(params[:key])
  end

end

