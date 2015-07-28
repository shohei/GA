g = GA.new
CSV.open('result.csv','w') do |csv|
  csv << ['generation','average_fitness']
  100000.times do
    g.evolution
    csv << [g.generation,g.ave_fitness]
  end
end

