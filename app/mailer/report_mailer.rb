class ReportMailer
  def self.configure
    @config ||= Mintoffice::Application.config.mailer
  end

  def self.report(target, from, to, subject, message)
    Pony.mail({
      :from => from.notify_email,
      :to => to.notify_email,
      :subject => subject,
      :body => message
    }.merge(configure)) if from.notify_email and to.notify_email
  end
end