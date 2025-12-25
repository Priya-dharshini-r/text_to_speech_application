class CreateVoiceGenerations < ActiveRecord::Migration[8.1]
  def change
    create_table :voice_generations do |t|
      t.text :text
      t.string :voice
      t.string :language
      t.string :provider
      t.integer :status
      t.string :audio_url
      t.text :error_message

      t.timestamps
    end
  end
end
