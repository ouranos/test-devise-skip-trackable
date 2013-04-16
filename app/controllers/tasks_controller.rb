class TasksController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  before_filter :skip_trackable, only: :new

  def index
    @tasks = Task.all
    respond_with @task
  end

  def new
    @tasks = Task.new
    respond_with @task
  end
end
