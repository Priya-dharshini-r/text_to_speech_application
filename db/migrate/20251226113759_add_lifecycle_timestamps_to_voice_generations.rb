class AddLifecycleTimestampsToVoiceGenerations < ActiveRecord::Migration[8.1]
  def change
    add_column :voice_generations, :processing_at, :datetime
    add_column :voice_generations, :completed_at, :datetime
    add_column :voice_generations, :failed_at, :datetime
  end
end
