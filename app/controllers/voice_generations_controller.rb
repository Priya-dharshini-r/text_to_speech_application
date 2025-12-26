class VoiceGenerationsController < ApplicationController
    protect_from_forgery with: :null_session
    
    def create
        voice_generation = current_user.voice_generations.create!(
        text: params[:text],
        voice: params[:voice],
        language: params[:language],
        status: :pending,
        provider: "elevenlabs"
    )

    VoiceGenerationJob.perform_later(voice_generation.id)

    render json: {
            id: voice_generation.id,
            status: voice_generation.status
        }, status: :created
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

        unless vg
            return render json: { status: "not_found" }, status: :ok
        end

        render json: {
            id: vg.id,
            status: vg.status,
            audio_url: vg.audio_url,
            processing_at: vg.processing_at,
            completed_at: vg.completed_at,
            failed_at: vg.failed_at
        }
    end
end
