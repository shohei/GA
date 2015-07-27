require 'gnuplot'
require 'csv'
require 'pry'

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    plot.title  "Solving Knapsack Problem with Genetic Algorithm"
    plot.xlabel "Generation"
    plot.ylabel "Average Fitness"

    table = CSV.table('result.csv')
    
    x = table[:generation]
    y = table[:average_fitness]

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      # ds.with = "linespoints"
      ds.with = "points"
    end

  end
end

