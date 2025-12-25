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
end
