require 'benchmark' 

Contact = Struct.new(:first_name, :last_name, :home_number, :cell_number, :email )

n = 10_000
Benchmark.bm do |x|
  x.report("Struct.new\n") do
     n.times do |i|
       Struct.new("Contact#{i}", :first_name, :last_name, :home_number, :cell_number, :email )
     end
   end
end 

n = 100_000
Benchmark.bm do |x|
  mattetti = Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
  lrz      = Contact.new('Laurent', 'Sansonetti', '123-456-5555', '555-444-3333', 'lrz@gmail.com')
  
  x.report("==\n") do
     n.times do
       mattetti == lrz
     end
   end
  
   x.report("eql?\n") do
      n.times do
        mattetti.eql?(lrz)
      end
    end
    
  x.report("new instance\n") do
     n.times do
       Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
     end
   end 
   
end 

n = 200_000
Benchmark.bm do |x|
  matt = Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
  x.report("attribute reference by string\n") do
     n.times{ matt['home_number'] }
  end 
  x.report("attribute reference by symbol\n") do
     n.times{ matt[:home_number] }
  end
  x.report("attribute reference by index\n") do
     n.times{ matt[2] }
  end
  x.report("each {|obj| block }\n") do
     n.times{ matt.each{|x| x} }
  end
  x.report("each_pair {|sym, obj| block }\n") do
     n.times{ matt.each_pair{|name, value| name} }
  end 
  x.report("length\n") do
     n.times{ matt.length }
  end
  x.report("members\n") do
     n.times{ matt.members }
  end
  x.report("select{|i| block}\n") do
     n.times{ matt.select{|i| true} }
  end 
  x.report("values_at(indexes)}\n") do
     n.times{ matt.values_at(1,3) }
  end
  x.report("values_at(negative indexes)}\n") do
     n.times{ matt.values_at(-1,-3) }
  end 
  x.report("values_at(ranges)}\n") do
     n.times{ matt.values_at(1..3, 2...5) }
  end
end 

n = 100_000
Benchmark.bm do |x|
  matt = Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
  
  x.report("hash\n") do
     n.times{ matt.hash }
  end
  x.report("to_s\n") do
     n.times{ matt.to_s }
  end
  x.report("to_a\n") do
   n.times{ matt.to_a } 
  end
end