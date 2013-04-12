class Task < ActiveRecord::Base
  attr_accessible :description, :due_date, :priority, :title
end
