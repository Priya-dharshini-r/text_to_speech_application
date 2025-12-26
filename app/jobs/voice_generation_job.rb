class VoiceGenerationJob < ApplicationJob
  queue_as :default

  def perform(voice_generation_id)
    voice_generation = VoiceGeneration.find(voice_generation_id)
    voice_generation.processing!

    # Create a temporary audio file (placeholder)
    file_path = "/tmp/voice_#{voice_generation.id}.mp3"
    File.write(file_path, "FAKE AUDIO DATA")

    # Upload to Supabase
    uploader = SupabaseUploader.new
    key = "voice_#{voice_generation.id}.mp3"
    audio_url = uploader.upload(file_path: file_path, key: key)

    voice_generation.update!(
      audio_url: audio_url,
      status: :completed
    )
  rescue => e
    voice_generation.update!(
      status: :failed,
      error_message: e.message
    )
  ensure
    File.delete(file_path) if file_path && File.exist?(file_path)
  end
end
