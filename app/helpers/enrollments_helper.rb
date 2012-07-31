# encoding: UTF-8

module EnrollmentsHelper
  def information_filled?(item_name)
    @enrollment.information_filled?(item_name) ? "등록 완료" : ""
  end
end