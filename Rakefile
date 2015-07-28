namespace :knapsack do
  desc "Solving Knapsack Problem using Genetic Algorithm"
  task :simulation, 'ntimes' do |task,args|
    require_relative './knapsack/ga'
    include Knapsack
    g = GA.new
    CSV.open('./knapsack/result.csv','w') do |csv|
      csv << ['generation','average_fitness']
      (args.ntimes).to_i.times do
        g.evolution
        csv << [g.generation,g.ave_fitness]
      end
    end
  end

end

