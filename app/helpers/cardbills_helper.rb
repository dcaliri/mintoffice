module CardbillsHelper
	def count(cardbills)
    cardbill_count = cardbills.count
    cardbill_count.class == Fixnum ? cardbill_count : cardbill_count.count
	end
end
