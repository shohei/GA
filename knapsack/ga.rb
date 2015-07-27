require 'csv'
require 'matrix'

class GA
  attr_accessor :codemasks, :fitnesses

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

    @fitnesses = calc_fitness
  end

  def calc_fitness
    @codemasks.map do |codemask|
      calc_each_fitness(codemask)
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

  def selection
    #elite selection
    elite_number = @fitnesses.index(@fitnesses.max)
    @fitnesses.tap{|a| a.delete_at(elite_number)}
    #roulette selection
    total_fitness = @fitnesses.inject(:+)
    @relative_fitnesses = Hash.new
    @fitnesses.each_with_index{|f,index| @relative_fitnesses[index] = (total_fitness/(f.to_f)).to_i}
    @relative_fitnesses
  end

end

p GA.new.selection



