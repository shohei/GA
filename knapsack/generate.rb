require 'faker'
require 'csv'


CSV.open('contents.csv','w') do |csv|
  csv << ['name','weight','price']
  (1..50).map do |i|
    name = Faker::Commerce.product_name
    weight = rand(1..10)
    price =  rand(1..40) 
    csv << [name,weight,price]
  end
end


