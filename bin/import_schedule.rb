require 'rubyXL'
require 'pry'

file = ARGV.shift || raise("You must supply a path")

workbook = RubyXL::Parser.parse file
rows     = workbook[0].to_a

rows.shift

headers = rows.shift
raise unless headers.cells.map(&:value) == [
  "Address", "Contact", "CAMPUS", "COURSE",
  "SPRING SCHEDULE", "SUMMER SCHEDULE", "FALL SCHEDULE ",
  "SPRING SCHEDULE", "SUMMER SCHEDULE", "FALL SCHEDULE "
]

def normalize_campus c
  {
    "Tampa-St. Pete" => "Tampa-St. Petersburg",
    "Washington, DC" => "Washington, D.C."
  }[c] || c
end

Campus.where(name: "London").first_or_create!

rows.
  select { |r| r && r.cells }.
  map { |r| r.cells.map { |c| c && c.value } }.
  each do |address, contact, campus, course, *dates|
    next unless dates.any? # There are a few lines at the end with key stuff

    if campus
      campus = normalize_campus campus
      begin
        @campus = Campus.where(name: campus).first!
      rescue => e
        puts "Could not find campus #{campus}"
        next
      end
    end

    begin
      @topic = Topic.where(title: course).first!
    rescue => e
      puts "Could not find course #{course}"
      next
    end

    # These are the 2015 dates
    dates.first(3).each do |range|
      next if range.nil? || range.empty? || range.downcase == "no class"
      range =~ /(\w+)\s+(\d+)\s+-/
      month, day = $1, $2
      start_date = Date.parse "#{month} #{day} 2015"

      course = Course.where(
        campus:   @campus,
        topic:    @topic,
        start_on: start_date,
        # Ew. FIXME.
        instructor_id: 1,
        organization:  ""
      ).first_or_initialize
      course.save! validate: false # Don't have instructor or organization
    end
end
