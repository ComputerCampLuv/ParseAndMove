require 'nokogiri'
require 'csv'
require 'date'

doc = Nokogiri::HTML(open("flashscores.html"), nil, 'UTF-8')
nbsp = Nokogiri::HTML("&nbsp;").text

doc.css("span .h2").each do |element|
  d = element.inner_text.split[0].split("/")
  day = d[0].to_i
  month = d[1].to_i
  date = Date.new(Date.today.year, month, day)
  puts date
end
doc.css(".table-main").each do |main|

  main.css(".soccer").each do |table|

    table.css("span .country_part").each do |country|
      print country.inner_text.strip.gsub(":", "") + ": "
    end

    table.css("span .tournament_part").each do |league|
      puts league.inner_text.strip
    end

  end

end

# doc.css("span .country_part").each do |element|
#     puts element.inner_text.strip.gsub(":", "").downcase
#   end