class VoiceGenerationsController < ApplicationController
  before_action :authenticate_user!

  def create
    vg = current_user.voice_generations.create!(
      voice_generation_params.merge(
        status: :pending,
        provider: "elevenlabs"
      )
    )

    VoiceGenerationJob.perform_later(vg.id)

    render json: { id: vg.id, status: vg.status }, status: :created
  end

  def index
    vgs = current_user.voice_generations.order(created_at: :desc)

    render json: vgs.map { |vg|
      {
        id: vg.id,
        text: vg.text,
        audio_url: vg.audio_url,
        status: vg.status
      }
    }
  end

  def show
    vg = current_user.voice_generations.find_by(id: params[:id])

    return render json: { status: "not_found" } unless vg

    render json: {
      id: vg.id,
      status: vg.status,
      audio_url: vg.audio_url
    }
  end

  private

  def voice_generation_params
    params.require(:voice_generation).permit(:text, :voice, :language)
  end
end
