class SupabaseUploader
  def initialize
    config = Rails.configuration.supabase

    @base_url = config["url"]
    @bucket   = config["bucket"]
    @api_key  = config["service_key"]
  end

  def upload(file_path:, key:)
    conn = Faraday.new(url: @base_url)

    response = conn.post(
      "/storage/v1/object/#{@bucket}/#{key}",
      File.binread(file_path),
      {
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type"  => "audio/mpeg"
      }
    )

    raise "Supabase upload failed: #{response.body}" unless response.success?

    "#{@base_url}/storage/v1/object/public/#{@bucket}/#{key}"
  end
end
