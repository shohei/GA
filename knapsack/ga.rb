require 'csv'
require 'matrix'
require 'pry'

module Knapsack

  class GA
    attr_accessor :generation, :fitnesses, :individuals, :children, :ave_fitness

    # @@wmax = 40
    @@wmax = 400
    @@num_of_individuals = 32

    def initialize
      @generation = 1

      data = CSV.table("#{__dir__}/contents.csv")
      names = data[:name]
      @weights = data[:weight]
      @prices = data[:price]
      @item_count = @prices.length

      @prices_vector = Vector.elements(@prices)
      @codemasks = @@num_of_individuals.times.map do 
        (1..@item_count).map{rand(0..1)}
      end
      @children = @codemasks #this is the ancestor, though it is called as 'children'

      @crossover_location = @item_count/2 #1点交叉の場合、半分の位置で交叉
    end

    def evolution
      @generation += 1
      @fitnesses = calc_fitness(@children)
      @individuals = selection(@fitnesses)
      @children = crossover(@individuals)
      @ave_fitness = @fitnesses.instance_eval { reduce(:+) / size.to_f }
    end

    def calc_fitness(individuals)
      fitnesses = []
      individuals.map do |codemask|
        fitnesses.push calc_each_fitness(codemask)
      end
      fitnesses
    end

    def calc_each_fitness(codemask)
      total_weight = @weights.inject(:+)
      mask_vector = Vector.elements(codemask) 
      if total_weight >= @@wmax 
        fitness = 1
      else
        fitness = @prices_vector.inner_product(mask_vector)
      end
      fitness
    end

    def selection(fitnesses)
      individuals = []
      #elite selection
      elite_number = fitnesses.index(fitnesses.max)
      individuals.push @codemasks[elite_number]
      fitnesses.tap{|a| a.delete_at(elite_number)} #remove elite

      #roulette selection
      total_fitness = fitnesses.inject(:+)
      @relative_fitnesses = [] 
      fitnesses.each_with_index do |f,index| 
        (total_fitness/(f.to_f)).to_i.times do 
          @relative_fitnesses.push index 
        end
      end

      (@@num_of_individuals-1).times do
        individuals.push @codemasks[@relative_fitnesses.sample]
      end
      individuals
    end

    def crossover(individuals)
      #1点交叉
      children = []
      (@@num_of_individuals/2).times do 
        father = individuals.sample
        mother = individuals.sample
        child1 = father[0,@crossover_location]+mother[@crossover_location-1,mother.length-@crossover_location]
        child2 = mother[0,@crossover_location]+father[@crossover_location-1,father.length-@crossover_location]
        children.push  child1
        children.push  child2
      end
      children
    end

    def mutation
      #TODO
      #ビット反転
      #反転確率はどのように決めたらよいか？
    end

  end
end

