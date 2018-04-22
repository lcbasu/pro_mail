class Email < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  has_many :sender_receivers
end
