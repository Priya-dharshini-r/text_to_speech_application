class VoiceGeneration < ApplicationRecord
  belongs_to :user  
  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  validates :text, presence: true
  validates :voice, presence: true
  validates :language, presence: true
  validates :provider, presence: true

  def mark_processing!
    update!(
      status: :processing,
      processing_at: Time.current
    )
  end

  def mark_completed!(audio_url)
    update!(
      status: :completed,
      audio_url: audio_url,
      completed_at: Time.current,
      error_message: nil
    )
  end

  def mark_failed!(error)
    update!(
      status: :failed,
      error_message: error.to_s,
      failed_at: Time.current
    )
  end
end
