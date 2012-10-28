require 'csv'
require 'open-uri'
require 'json'

require Rails.root.join('app','helpers','geocode_helper.rb')
include GeocodeHelper

namespace :data do

	HOSPITALS_FILE = Rails.root.join('db', 'hos-1-u8.csv')
	AEDS_FILE = Rails.root.join('db', 'aeds.gangnam.csv')

	desc "load hospital data"
	task :load_hospitals => :environment do
		Hospital.delete_all
		CSV.parse(File.read(HOSPITALS_FILE)) do |row|
			p row
			code, name, category, phone, zipcode, address, antibiotics, injections = row
			Hospital.create( code: code, name: name, category: category, phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics)
		end
	end

	desc "update hospital data"
	task :update_hospitals => :environment do
		CSV.parse(File.read(HOSPITALS_FILE)) do |row|
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

	desc "geocode hospital data"
	task :geocode_hospitals => :environment do
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

	# "신사동","신사동 548-1","주민센터 민원실 내","3443-6560","1"
	desc "load aeds"
	task :load_aeds => :environment do

		type = :aed

		Place.type(type).delete

		CSV.parse(File.read(AEDS_FILE)) do |row|
			puts row
			info = {}
			name, address, info[:address_desc], info[:phone] = row
			coordinates = geocode(address)

			Place.create!( type: type, name: name, address: address, coordinates: coordinates, info: info )
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

# should update data
# { "_id" : ObjectId("5050bcb043cd2af0130037f7"), "address" : "경기도 군포시 오금로 43", "antibiotics" : "4", "category" : "의원", "code" : "41319320", "coordinates" : [ 126.931953, 37.353920 ], "created_at" : ISODate("2012-09-12T16:47:44.021Z"), "injections" : "2", "name" : "미소이비인후과의원", "phone" : "031-398-8275", "updated_at" : ISODate("2012-09-17T07:36:54.726Z"), "zipcode" : "(435050)" }