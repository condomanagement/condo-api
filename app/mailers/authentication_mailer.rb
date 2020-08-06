# frozen_string_literal: true

class AuthenticationMailer < ApplicationMailer
  def registration(authentication)
    @authentication = authentication
    mail(to: @authentication.user[:email], subject: I18n.t("email.authentication.login"))
  end
end
