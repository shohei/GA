require 'gnuplot'
require 'csv'
require 'pry'

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    plot.title  "Array Plot Example"
    plot.xlabel "weight"
    plot.ylabel "price"

    table = CSV.table('contents.csv')
    
    # x = (0..50).collect { |v| v.to_f }
    # y = x.collect { |v| v ** 2 }
    x = table[:weight]
    y = table[:price]

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      # ds.with = "linespoints"
      ds.with = "points"
    end
  end
end


