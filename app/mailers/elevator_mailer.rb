# frozen_string_literal: true

class ElevatorMailer < ApplicationMailer
  def pending(elevator_booking)
    @elevator_booking = elevator_booking
    mail(to: @elevator_booking.user.email, subject: I18n.t("email.elevator.pending_subject"))
  end

  def notification(elevator_booking)
    @elevator_booking = elevator_booking
    to = if @elevator_booking.moveType == 2
      ENV.fetch("ELEVATOR_EMAIL_MOVE", nil)
    else
      ENV.fetch("ELEVATOR_EMAIL_DELIVERY", nil)
    end

    mail(
      to: to,
      reply_to: @elevator_booking.user.email,
      subject: I18n.t("email.elevator.pending_notification_subject")
    )
  end

  def approval(elevator_booking)
    @elevator_booking = elevator_booking
    mail(to: @elevator_booking.user.email, subject: I18n.t("email.elevator.approved_subject"))
  end

  def rejection(elevator_booking)
    @elevator_booking = elevator_booking
    mail(to: @elevator_booking.user.email, subject: I18n.t("email.elevator.rejected_subject"))
  end
end
