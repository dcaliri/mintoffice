class StripApproveNumber < ActiveRecord::Migration
  class CardUsedSource < ActiveRecord::Base
  end
  class CardApprovedSource < ActiveRecord::Base
  end
  class Cardbill < ActiveRecord::Base
  end

  def up
    CardUsedSource.all.each do |source|
      if source.approve_no
        source.approve_no = source.approve_no.strip
        source.save!
      end
    end

    CardApprovedSource.all.each do |source|
      if source.approve_no
        source.approve_no = source.approve_no.strip
        source.save!
      end
    end

    Cardbill.all.each do |cardbill|
      if cardbill.approveno
        cardbill.approveno = cardbill.approveno.strip
        cardbill.save!
      end
    end
  end

  def down
  end
end
