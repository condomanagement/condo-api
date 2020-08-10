# frozen_string_literal: true

class AuthenticationMailer < ApplicationMailer
  def registration(authentication)
    @authentication = authentication
    @link = ENV["DOMAIN"] + "/authenticate/" + @authentication[:emailtoken]
    mail(to: @authentication.user[:email], subject: I18n.t("email.authentication.subject"))
  end
end
