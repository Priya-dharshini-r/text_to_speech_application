class VoiceGenerationJob < ApplicationJob
  queue_as :default

  def perform(voice_generation_id)
    voice_generation = VoiceGeneration.find(voice_generation_id)

    voice_generation.processing!

    # Placeholder for actual voice generation logic.
    fake_audio_url = "https://example.com/audio/#{voice_generation.id}.mp3"

    voice_generation.update!(
      audio_url: fake_audio_url,
      status: :completed
    )
  rescue => e
    voice_generation.update!(
      status: :failed,
      error_message: e.message
    )
  end
end
