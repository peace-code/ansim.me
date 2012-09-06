namespace :data do
	desc "load data"
	task :load_file => :environment do

		Hospital.delete_all

		data = JSON.parse(File.read("#{Rails.root.to_s}/db/data.txt"))
		
		data.each do |row|
			Hospital.create( name: row['NAME'], phone: row['PHONE'], homepage: row['HOMEPAGE'], address: row['ADDR'], coordinates: [row['LATITUDE'], row['LONGITUDE']])
		end
	end	
end