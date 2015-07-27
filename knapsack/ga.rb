require 'csv'
require 'matrix'
require 'pry'

class GA
  attr_accessor :codemasks, :fitnesses

  @@wmax = 40
  @@num_of_individuals = 32

  def initialize
    data = CSV.table('contents.csv')
    names = data[:name]
    @weights = data[:weight]
    @prices = data[:price]

    @prices_vector = Vector.elements(@prices)
    @codemasks = @@num_of_individuals.times.map do 
      (1..50).map{rand(0..1)}
    end

    @fitnesses = calc_fitness
    @individuals = []
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
    @individuals.push @codemasks[elite_number]
    @fitnesses.tap{|a| a.delete_at(elite_number)} #remove elite
    
    #roulette selection
    total_fitness = @fitnesses.inject(:+)
    @relative_fitnesses = [] 
    @fitnesses.each_with_index do |f,index| 
      (total_fitness/(f.to_f)).to_i.times do 
       @relative_fitnesses.push index 
      end
    end

    (@@num_of_individuals-1).times do
      @individuals.push @codemasks[@relative_fitnesses.sample]
    end
    @individuals
  end

  def crossover
    #TODO
    #２点交叉を用いる？
  end

  def mutation
    #TODO
    #ビット反転
    #反転確率はどのように決めたらよいか？
  end

end

binding.pry
g =  GA.new.selection



