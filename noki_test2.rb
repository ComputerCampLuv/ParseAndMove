require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'
require 'csv'

doc = Nokogiri::HTML(open("flashscores.html"), nil, 'UTF-8')
nbsp = Nokogiri::HTML("&nbsp;").text

country = ""
league = ""
start_year = ""
end_year = ""

doc.css('.tournament a').each_with_index do |a, index|
  case index
    when 1 then country = a.inner_text
    when 2 then league = a.inner_text
    else
      # do nothing
  end
end

doc.css('.tournament').each do |a|
  year =  a.inner_text.split[-1]
  years = year.split("/")
  start_year = years[0]
  end_year = years[1]
end

filename = "#{country}_#{league.gsub(' ', '_')}_#{start_year}-#{end_year}.csv"

CSV.open("season_details.csv", "wb") do |csv|
  csv << [country, league, start_year, end_year]
end

home_teams = []

doc.css(".team-home").each do |team| 
  home_teams << team.inner_text.gsub(nbsp, ' ').downcase.strip
end

away_teams = []

doc.css(".team-away").each do |team| 
  away_teams << team.inner_text.gsub(nbsp, ' ').downcase.strip
end

home_team_goals = []
away_team_goals = []

doc.css(".score").each do |score| 
  score = score.inner_text.split("#{nbsp}:#{nbsp}")
  home_team_goals << score[0]
  away_team_goals << score[1]
end

match_dates = []

doc.css(".time").each do |date_time| 
  date_time = date_time.inner_text.split(". ")

  date = date_time[0]
  date = date.split(".")
  day = date[0].to_i
  month = date[1].to_i

  time = date_time[1]
  time = time.split(":")
  hours = time[0].to_i
  minutes = time[1].to_i

  match_dates << DateTime.new(
    if month < 7
      end_year.to_i
    else
      start_year.to_i
    end,
    month, day, hours, minutes)  
end

count = home_teams.length

CSV.open("game_details.csv", "wb") do |csv| 
  csv << ["home_team", "away_team", "home_team_goals", "away_team_goals", "match_date"]

  count.times do |index|
    csv << [home_teams[index], away_teams[index], home_team_goals[index], away_team_goals[index], match_dates[index]]
    # print "#{'%20.20s' % home_teams[index]}"
    # print "#{'%3.3s' % home_team_goals[index]} - "
    # print "#{'%-3.3s' % away_team_goals[index]}"
    # print "#{'%-20.20s' % away_teams[index]} |"
    # puts "#{'%20.20s' % match_dates[index].strftime("%e %B %Y")}"
  end
end