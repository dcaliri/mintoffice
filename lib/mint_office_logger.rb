module MintOfficeLogger
	def add_to_fix_me_log(deprecated_method)
		mint_logger = Logger.new(Rails.root.join('log', 'mintoffice_logger.log'))

		mint_logger.info(" >>>>>>> FIXME ::: #{deprecated_method} is deprecated <<<<<")
		caller.each do |from| 
		  break unless from.match(/mintoffice/)
		  mint_logger.info("     >>> #{from}")
		end

	rescue
		'MINT_OFFICE_LOGGER ERROR!!!!'
	end
end