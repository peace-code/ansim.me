require 'csv'
require 'open-uri'
require 'json'

require Rails.root.join('app','helpers','geocode_helper.rb')
require Rails.root.join('app','helpers','database_helper.rb')
include GeocodeHelper
include DatabaseHelper

namespace :data do

	APIKEY = YAML.load_file(Rails.root.join('config','apikey.yml'))['daum']
	HOSPITALS_FILE = Rails.root.join('db', 'hos-1-u8.csv')
	AEDS_FILE = Rails.root.join('db', 'aeds.gangnam.csv')
	FOODS_FILE = Rails.root.join('db', 'ansimfood.csv')

	desc "load hospital data"
	task :load_hospitals => :environment do
		Hospital.delete_all
		CSV.parse(File.read(HOSPITALS_FILE)) do |row|
			p row
			code, name, category, phone, zipcode, address, antibiotics, injections = row
			Hospital.create( code: code, name: name, category: category, phone: phone, zipcode: zipcode, address: address, antibiotics: antibiotics)
			sleep 0.42
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

	# should update one data after geocode_hospitals
	# { "_id" : ObjectId("5050bcb043cd2af0130037f7"), "address" : "경기도 군포시 오금로 43", "antibiotics" : "4", "category" : "의원", "code" : "41319320", "coordinates" : [ 126.931953, 37.353920 ], "created_at" : ISODate("2012-09-12T16:47:44.021Z"), "injections" : "2", "name" : "미소이비인후과의원", "phone" : "031-398-8275", "updated_at" : ISODate("2012-09-17T07:36:54.726Z"), "zipcode" : "(435050)" }	desc "geocode hospital data"
	task :geocode_hospitals => :environment do
		hospitals = Hospital.where(coordinates: nil)
		hospitals.each do |hospital|
			p hospital.address
			url = "http://apis.daum.net/local/geo/addr2coord?apikey=#{APIKEY}&output=json&q=#{hospital.address}"
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
			name, address, info[:address_desc], phone = row
			# coordinates = geocode(address)

			Place.create!(
				type: type,
				name: name,
				address: address,
				# coordinates: coordinates,
				phone: phone,
				info: info
			)
			sleep 0.42
		end
	end

	# 자료수집주기는 6개월이고 좌표는 세계측지좌표계(ITRF2000)
	# 연번,구분,구분설명,지역,업소명,X,Y,주소,연락처
	# 306,1,원산지표시 우수음식점,1,한우리외식산업(주),203073.5486,446852.3622,강남구 논현동 91-18 ,545-3334
	desc "load foods"
	task :load_foods => :environment do

		type = :food
		Place.type(type).delete

		CSV.parse(File.read(FOODS_FILE)) do |row|

			puts row

			begin
				info = {}

				dummy, category, category_desc, dummy, name, dummy, dummy, address, phone = row
				# coordinates = geocode(address)

				Place.create!(
					type: type,
					category: category,
					category_desc: category_desc,
					name: name,
					address: address,
					# coordinates: coordinates,
					phone: phone,
					info: info
				)
				sleep 0.42
			rescue
				p "ERROR"
			end
		end
	end

	desc "city"
	task :city => :environment do
		City.delete_all
		CSV.parse(File.read("#{Rails.root.to_s}/db/city.txt"), col_sep:"\t") do |row|
			p row
			city, subcity = row
			c = City.create( city: city, subcity: subcity, address: "#{city} #{subcity}")
			p c.coordinates
			sleep 0.42
		end
	end

	desc "Get AED Places from web pages"
	task :get_aeds => :environment do
		type = :aed
		Place.type(type).delete
		begin_n = 1275; thru_n = 1277# [..) 1277
		n = begin_n
		begin
			cnt = 0
			puts "EGEN,FETCH,#{n}"
  		aed_places = DatabaseHelper::egen_get_list n
      unless aed_places.nil? 
        aed_places.each do |el|
          aed = el['href']
          unless aed.empty?
            cnt = cnt + 1
            aed = aed.split("'")
            name = aed[1].gsub(/,/,'_')
            sn = aed[9]
            begin
              info = {}
              info[:category], address, phone, info[:address_desc], nop, info[:create_at], info[:model] = egen_print_info sn
              info[:sn] = sn
              print type, ",", name, ",", address[13..-1], ",", phone, ",", info, "\n" if Rake.application.options.trace == true
              Place.create!(
								type: type,
								name: name,
								address: address,
								phone: phone,
								info: info
							)
            rescue OpenURI::HTTPError
              puts "ERROR,#{n},#{cnt},NOT_FOUND,-"
              next
            end
          end
        end #aed_places
      end
      n = n + 1
      sleep 0.42
		end while 0 < cnt && n < thru_n
		puts "EGEN,#{n},END"
	end
end