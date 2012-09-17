require 'csv'
require 'open-uri'
require 'json'

namespace :data do

	DATAFILE = "#{Rails.root.to_s}/db/hos-1-u8.csv"

	desc "load data"
	task :load_file => :environment do
		Hospital.delete_all
		CSV.parse(File.read(DATAFILE)) do |row|
			p row
			code, name, category, phone, zipcode, address, antibiotics, injections = row
			Hospital.create( code: code, name: name, category: category, phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics)
		end
	end	

	desc "update data"
	task :update => :environment do
		CSV.parse(File.read(DATAFILE)) do |row|
			code, name, category, phone, zipcode, address, antibiotics, injections = row
			hospital = Hospital.where(code: code).first
			if hospital
				hospital.update_attributes(phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics, injections: injections)
				p "updated #{code}"
			else
				Hospital.create( code: code, name: name, category: category, phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics)
				p "created #{code}"
			end
		end
	end

	desc "geocode"
	task :geocode => :environment do
		hospitals = Hospital.where(coordinates: nil)
		hospitals.each do |hospital|
			p hospital.address
			url = "http://apis.daum.net/local/geo/addr2coord?apikey=d6c46bdc42bfcbadad8458e2699b991423207468&output=json&q=#{hospital.address}"
			result = JSON.parse(open(URI.encode(url)).read)
			items = result['channel']['item']
			unless items.blank?
				item = items.first
				hospital.coordinates = [item['lng'], item['lat']]
				hospital.save()
			end
		end
	end

	desc "city"
	task :city => :environment do
		City.delete_all
		CSV.parse(File.read("#{Rails.root.to_s}/db/city.txt"), col_sep:"\t") do |row|
			p row
			city, subcity = row
			City.create( city: city, subcity: subcity, address: "#{city} #{subcity}")
		end
	end
end