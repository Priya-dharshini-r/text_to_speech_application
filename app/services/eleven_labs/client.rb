module ElevenLabs
  class Client
    BASE_URL = "https://api.elevenlabs.io/v1/text-to-speech"

    def initialize
      config = Rails.configuration.elevenlabs
      @api_key = config["api_key"]
      @voice_id = config["voice_id"]
      @model_id = config["model_id"]
    end

    def generate_audio(text)
      response = Faraday.post("#{BASE_URL}/#{@voice_id}") do |req|
        req.headers["xi-api-key"] = @api_key
        req.headers["Content-Type"] = "application/json"
        req.body = {
          text: text,
          model_id: @model_id
        }.to_json
      end

      raise "ElevenLabs failed: #{response.body}" unless response.success?

      response.body # MP3 binary
    end
  end
end
