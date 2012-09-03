class ReportMailer
  def self.configure
    @config ||= Mintoffice::Application.config.mailer
  end

  def self.report(target, from, to, subject, message)
    from_mail = from.account.notify_email
    to_mail = to.account.notify_email

    Pony.mail({
      :from => from_mail,
      :to => to_mail,
      :subject => subject,
      :body => message
    }.merge(configure)) if from_mail and to_mail
  rescue
  end
end