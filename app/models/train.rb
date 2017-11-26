#
class Train < ApplicationRecord
  validates_presence_of :number
  has_many :reservations

  mount_uploader :train_logo, TrainLogoUploader

  SEATS = begin
    (1..1).to_a.map do |series|
      %w[A B C D F].map do |letter|
        "#{series}#{letter}"
      end
    end
  end.flatten

  def available_seats
    SEATS - reservations.pluck(:seat_number)
  end
end
