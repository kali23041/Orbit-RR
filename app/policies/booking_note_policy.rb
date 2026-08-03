class BookingNotePolicy < ApplicationPolicy
  def create?
    record.booking.participant?(user)
  end
end
