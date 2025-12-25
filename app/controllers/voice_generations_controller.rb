class VoiceGenerationsController < ApplicationController
    protect_from_forgery with: :null_session
    
    def create
        voice_generation = current_user.voice_generations.create!(
        text: params[:text],
        voice: params[:voice],
        language: params[:language],
        provider: "elevenlabs",
        status: :pending
        )

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
        voice_generation = current_user.voice_generations.find(params[:id])

        render json: voice_generation
    end
end
