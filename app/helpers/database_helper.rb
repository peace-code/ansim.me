module DatabaseHelper

require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'timeout'

TIMEOUT_CNT = 42

  def egen_print_info code
    retries = TIMEOUT_CNT
    begin
      Timeout::timeout(5) {
        ret = []
        doc = Nokogiri::HTML(open("http://www.e-gen.or.kr/egen/inf.AED2.do?yearSeq=#{code}?HPID="))
        doc.xpath('//ul/li').each do |a|
          header, data = a.text.gsub(/[\t]/, '').gsub(/\r\n/, ' ').gsub(/,/,'_').split(': ')
          ret.push(data)
        end
        ret
      }
    rescue Timeout::Error
      retries -= 1
      if retries > 0 
        puts "sleep"
        sleep 1.42
        retry
      else
        puts "raise"
        raise
      end
    end
  end # def print_info

  def egen_get_list n
    retries = TIMEOUT_CNT
    elements = nil
    begin
      cnt = 0
      Timeout::timeout(5) {
        doc = Nokogiri::HTML(open("http://www.e-gen.or.kr/egen/inf.AED1.do?lon=&lat=&cnt=2444&str_cnt=0&page_num=1&page_size=100000&radius=400000&x=20&y=15&page=#{n}"))
        elements = doc.xpath('//td/b/a')
      }
    rescue Timeout::Error
      retries -= 1
      if retries > 0 
        puts "sleep"
        sleep 1.42
        retry
      else
        puts "raise"
        raise
      end
    end
    elements
  end
end