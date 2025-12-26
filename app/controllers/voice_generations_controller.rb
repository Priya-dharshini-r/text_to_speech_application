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
        voice_generations = current_user.voice_generations
                                    .order(created_at: :desc)

        render json: voice_generations
    end

    def show
        vg = current_user.voice_generations.find(params[:id])
        render json: {
            id: vg.id,
            status: vg.status,
            audio_url: vg.audio_url,
            processing_at: vg.processing_at,
            completed_at: vg.completed_at,
            failed_at: vg.failed_at,
            error_message: vg.error_message
        }
    end
end
