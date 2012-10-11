module ContactsHelper
  def interleave_phone_numbers(contacts)
    list = contacts.map do |contact| 
      contact.phone_numbers.map do |number| 
        number.number
      end
    end

    interleave(list)
  end

  def interleave_emails(contacts)
    list = contacts.map do |contact| 
      contact.emails.map do |email| 
        email.email
      end
    end

    interleave(list)
  end
end