module EmploymentProof
  def generate_employment_proof(purpose)
    filename = "#{Rails.root}/tmp/#{fullname}_employment_proof.pdf"
    template = "#{Rails.root}/app/assets/images/employment_proof_tempate.pdf"
    hash_key = Time.now.utc.strftime("%Y%m%d%H%M%S") + id.to_s + Array.new(10).map { (65 + rand(58)).chr }.join
    hash_key = Digest::SHA1.hexdigest(hash_key)

    Prawn::Document.generate(filename, template: template) do |pdf|
      pdf.image company.seal, :at => [320, 255], width: 50, height: 50
      pdf.image company.seal, :at => [415, 463], width: 50, height: 50

      pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
      pdf.font_size 12

      pdf.draw_text fullname, :at => [142, 685]
      pdf.draw_text juminno, :at => [142, 661]
      pdf.draw_text address.strip, :at => [142, 637]
      pdf.draw_text department, :at => [142, 526]
      pdf.draw_text position, :at => [333, 526]

      pdf.draw_text company.name, :at => [142, 613]
      pdf.draw_text company.registration_number, :at => [333, 613]
      pdf.draw_text company.owner_name, :at => [142, 589]
      pdf.draw_text company.address, :at => [142, 558]
      pdf.draw_text company.phone_number, :at => [333, 589]

      pdf.draw_text work_from.year, :at => [168, 494]
      pdf.draw_text work_from.month, :at => [220, 494]
      pdf.draw_text work_from.day, :at => [252, 494]

      pdf.draw_text work_to.year, :at => [318, 494]
      pdf.draw_text work_to.month, :at => [370, 494]
      pdf.draw_text work_to.day, :at => [402, 494]

      # pdf.draw_text company.employees.not_retired.count, :at => [402, 494]
      pdf.draw_text Employee.not_retired.count, :at => [142, 460]
      pdf.draw_text purpose, :at => [333, 460]

      pdf.draw_text I18n.t('models.employee.representative'), :at => [175, 433]
      pdf.draw_text company.owner_name, :at => [385, 433]

      today = Time.zone.now
      pdf.draw_text today.year, :at => [198, 311]
      pdf.draw_text today.month, :at => [262, 311]
      pdf.draw_text today.day, :at => [306, 311]

      pdf.draw_text company.name, :at => [250, 255]
      pdf.draw_text company.owner_name, :at => [250, 225]

      pdf.draw_text I18n.t('models.employee.code')+"#{hash_key}", :at => [14, 45], :size => 10
    end

    employment_proof_hash << hash_key
    save!

    filename
  end
end