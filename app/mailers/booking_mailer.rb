class BookingMailer < ApplicationMailer
  def reminder(booking)
    @booking = booking
    mail(
      to: [ booking.learner.email, booking.mentor_user.email ],
      subject: "Orbit session starts soon"
    )
  end

  def completed(booking)
    @booking = booking
    mail(to: booking.learner.email, subject: "Session completed — leave a review on Orbit")
  end

  def cancelled(booking)
    @booking = booking
    mail(
      to: [ booking.learner.email, booking.mentor_user.email ],
      subject: "Orbit session cancelled"
    )
  end
end
