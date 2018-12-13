require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'
require 'csv'

# print "Country? "
# country = gets.chomp.downcase.gsub(' ', '_')

# print "League? "
# league = gets.chomp.downcase.gsub(' ', '_')

# print "What year did the season start? "
# year = gets.chomp.to_i

# doc = Nokogiri::HTML(open("flashscores.html"), nil, 'UTF-8')
nbsp = Nokogiri::HTML("&nbsp;").text

# home_teams = []

# doc.css(".team-home").each do |team| 
#   home_teams << team.inner_text
# end

# away_teams = []

# doc.css(".team-away").each do |team| 
#   away_teams << team.inner_text
# end

# home_team_goals = []
# away_team_goals = []

# doc.css(".score").each do |score| 
#   score = score.inner_text.split("#{nbsp}:#{nbsp}")
#   home_team_goals << score[0]
#   away_team_goals << score[1]
# end

# match_dates = []

# doc.css(".time").each do |date_time| 
#   date_time = date_time.inner_text.split(". ")

#   date = date_time[0]
#   date = date.split(".")
#   day = date[0].to_i
#   month = date[1].to_i

#   time = date_time[1]
#   time = time.split(":")
#   hours = time[0].to_i
#   minutes = time[1].to_i

#   match_dates << DateTime.new(
#     if month < 7
#       year + 1
#     else
#       year
#     end,
#     month, day, hours, minutes)  
# end

# count = home_teams.length

# CSV.open("#{country}_#{league}_#{year}-#{year + 1}.csv", "wb") do |csv| 
#   csv << ["home_team", "away_team", "home_team_goals", "away_team_goals", "match_date"]

#   count.times do |index|
#     csv << [home_teams[index], away_teams[index], home_team_goals[index], away_team_goals[index], match_dates[index]]
#     # print "#{'%20.20s' % home_teams[index]}"
#     # print "#{'%3.3s' % home_team_goals[index]} - "
#     # print "#{'%-3.3s' % away_team_goals[index]}"
#     # print "#{'%-20.20s' % away_teams[index]} |"
#     # puts "#{'%20.20s' % match_dates[index].strftime("%e %B %Y")}"
#   end
# end

# csv = CSV.parse("english_premier_league_2017-2018.csv", :headers => true)
# csv.each do |row|
#   thing = row.to_hash.symbolize_keys
#   puts thing.length
# end

teams = []
matches = []

CSV.foreach("english_premier_league_2017-2018.csv", headers: true) do |row|
  teams << row[0].gsub(nbsp, ' ').downcase.strip
  matches << {home_team: row[0], away_team: row[1], home_team_goals: row[2].to_i, away_team_goals: row[3].to_i, match_date: DateTime.parse(row[4])}
end

puts teams.uniq.count
puts teams.count(teams[0])
# puts teams.uniq[10] == teams.uniq[30]
uniq_teams = []

teams.each do |team| 
  if teams.count(team) > 10 
    uniq_teams << team
  end
end

puts uniq_teams.length
uniq_teams.uniq!
puts uniq_teams.length