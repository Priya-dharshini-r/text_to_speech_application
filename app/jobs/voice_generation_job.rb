class VoiceGenerationJob < ApplicationJob
  queue_as :default

  def perform(voice_generation_id)
    vg = VoiceGeneration.find(voice_generation_id)

    # Mark as processing (sets processing_at)
    vg.mark_processing!

    # Generate audio from ElevenLabs
    audio_binary = ElevenLabs::Client
                     .new
                     .generate_audio(vg.text)

    # Write temp file
    file_path = Rails.root.join("tmp", "voice_#{vg.id}.mp3")
    File.binwrite(file_path, audio_binary)

    # Upload to Supabase
    audio_url = SupabaseUploader.new.upload(
      file_path: file_path,
      key: "voice_#{vg.id}.mp3"
    )

    # Mark completed (sets completed_at + audio_url)
    vg.mark_completed!(audio_url)

  rescue => e
    # Mark failed (sets failed_at + error_message)
    vg.mark_failed!(e)
    raise

  ensure
    # Cleanup temp file
    File.delete(file_path) if defined?(file_path) && File.exist?(file_path)
  end
end
