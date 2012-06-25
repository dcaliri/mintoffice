class ReportMailer
  def self.configure
    @config ||= OpenStruct.new(YAML.load_file('config/mailer.yml'))
  end

  def self.report(target, from, to, subject, message)
    Pony.mail({
      :from => from.notify_email,
      :to => to.notify_email,
      :subject => subject,
      :body => message,
      :via => :smtp,
      :via_options => {
        :address              => configure.address,
        :port                 => configure.port,
        :enable_starttls_auto => true,
        :user_name            => configure.username,
        :password             => configure.password,
        :authentication       => :plain,
        :domain               => configure.domain
      }
    })
  end
end