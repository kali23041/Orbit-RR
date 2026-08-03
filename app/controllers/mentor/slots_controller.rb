module Mentor
  class SlotsController < BaseController
    def create
      slot = mentor_profile.availability_slots.new(slot_params)

      if slot.save
        redirect_to mentor_dashboard_path, notice: "Availability added."
      else
        redirect_to mentor_dashboard_path, alert: slot.errors.full_messages.to_sentence
      end
    end

    def destroy
      slot = mentor_profile.availability_slots.find(params[:id])
      if slot.open?
        slot.destroy!
        redirect_to mentor_dashboard_path, notice: "Slot removed."
      else
        redirect_to mentor_dashboard_path, alert: "Booked slots cannot be deleted."
      end
    end

    private

    def slot_params
      params.require(:availability_slot).permit(:starts_at, :ends_at)
    end
  end
end
