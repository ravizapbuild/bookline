class UpdateskuJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep(10)
    puts "Update SKU Job is running"
    puts args[0]
  end
end
