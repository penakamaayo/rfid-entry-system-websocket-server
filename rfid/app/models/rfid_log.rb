class RfidLog < ActiveRecord::Base

	def self.search(search)
		if search
			# find(:all, :conditions => ["card_rfid LIKE ? OR full_name LIKE ? OR first_name LIKE ?", "%#{search}%","%#{search}%","%#{search}%"] )
			find(:all, :conditions => ["card_rfid LIKE ? OR full_name LIKE ? OR id_number LIKE ? OR classification LIKE ?" ,"%#{ search}%","%#{search}%","%#{search}%","%#{search}%"] )
			
		else
			find(:all)
		end
	end

end
