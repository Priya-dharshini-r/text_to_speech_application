class VoiceGenerationJob < ApplicationJob
  queue_as :default

  def perform(voice_generation_id)
    vg = VoiceGeneration.find(voice_generation_id)
    vg.processing!

    # Generate audio from ElevenLabs
    audio_binary = ElevenLabs::Client.new.generate_audio(vg.text)

    # Save temp file
    file_path = Rails.root.join("tmp", "voice_#{vg.id}.mp3")
    File.binwrite(file_path, audio_binary)

    # Upload to Supabase
    uploader = SupabaseUploader.new
    audio_url = uploader.upload(
      file_path: file_path,
      key: "voice_#{vg.id}.mp3"
    )

    # Update DB
    vg.update!(
      status: :completed,
      audio_url: audio_url
    )
  rescue => e
    vg.update!(
      status: :failed,
      error_message: e.message
    )
    raise
  ensure
    File.delete(file_path) if file_path && File.exist?(file_path)
  end
end
