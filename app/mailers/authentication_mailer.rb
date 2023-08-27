# frozen_string_literal: true

class AuthenticationMailer < ApplicationMailer
  def registration(my_authentication)
    @my_authentication = my_authentication
    @link = "#{ENV.fetch("DOMAIN", nil)}/authenticate/#{@my_authentication[:emailtoken]}"
    mail(to: @my_authentication.user[:email], subject: I18n.t("email.authentication.subject"))
  end
end
