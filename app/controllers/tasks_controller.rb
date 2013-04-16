class TasksController < ApplicationController
  respond_to :json

  before_filter :skip_trackable, only: :new

  before_filter :authenticate_user!

  def index
    @tasks = Task.all
    respond_with @task
  end

  def new
    @tasks = Task.new
    respond_with @task
  end
end
