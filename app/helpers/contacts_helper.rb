module ContactsHelper
  def interleave_phone_numbers(contacts)
    list = contacts.map do |contact| 
      contact.phone_numbers.map(&:number)
    end

    interleave(list)
  end

  def interleave_emails(contacts)
    list = contacts.map do |contact| 
      contact.emails.map(&:email)
    end

    interleave(list)
  end
end