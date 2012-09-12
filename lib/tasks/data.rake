require 'csv'

namespace :data do
	desc "load data"
	task :load_file => :environment do

		Hospital.delete_all

		CSV.parse(File.read("#{Rails.root.to_s}/db/hos-u8.csv")) do |row|
			p row
			code, name, category, phone, zipcode, address, antibiotics = row
			Hospital.create( code: code, name: name, category: category, phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics)
		end

		Hospital.first.remove
	end	
end