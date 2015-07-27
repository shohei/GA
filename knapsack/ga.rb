require 'csv'
require 'matrix'

class GA
  attr_accessor :codemasks

  @@wmax = 40
  @@individuals = 32

  def initialize
    data = CSV.table('contents.csv')
    names = data[:name]
    @weights = data[:weight]
    prices = data[:price]

    @prices_vector = Vector.elements(prices)
    @codemasks = @@individuals.times.map do 
      (1..50).map{rand(0..1)}
    end
  end

  def calc_each_fitness(codemask)
    total_weight = @weights.inject(:+)
    mask_vector = Vector.elements(codemask) 
    if total_weight >= @@wmax 
      @fitness = 1
    else
      @fitness = @prices_vector.inner_product(mask_vector)
    end
    @fitness
  end

  def calc_fitness
    @codemasks.map do |codemask|
      calc_each_fitness(codemask)
    end
  end

end


g = GA.new
p g.codemasks
p g.calc_fitness







