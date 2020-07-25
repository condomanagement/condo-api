# frozen_string_literal: true

module ActionMailerHelpers
  include ActiveJob::TestHelper

private

  def action_mailer_job(mailer_class, mailer_method, *args)
    {
      job: ActionMailer::DeliveryJob,
      args: [
        mailer_class.to_s,
        mailer_method,
        "deliver_now",
        *ActiveJob::Arguments.serialize(args)
      ],
      queue: "mailers"
    }
  end
end
