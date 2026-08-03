# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/reminder
  def reminder
    BookingMailer.reminder
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/completed
  def completed
    BookingMailer.completed
  end

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/cancelled
  def cancelled
    BookingMailer.cancelled
  end
end
