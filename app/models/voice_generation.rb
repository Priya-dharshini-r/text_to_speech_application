class VoiceGeneration < ApplicationRecord
    enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
  
  belongs_to :user

  validates :text, presence: true, length: { maximum: 5_000 }
  validates :voice, presence: true
  validates :language, presence: true
  validates :provider, presence: true
  validates :status, presence: true
end
