class BookingPolicy < ApplicationPolicy
  def show?
    record.participant?(user)
  end

  def cancel?
    show? && record.cancellable?
  end

  def complete?
    show? && record.confirmed?
  end

  def ics?
    show?
  end
end
