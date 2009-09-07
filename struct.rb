require File.expand_path('herbs_helper') 

Contact = Struct.new(:first_name, :last_name, :home_number, :cell_number, :email )

m = 10_000
n = 100_000
o = 200_000

Benchmark.bm do |x|
  x.bench("Struct.new\n", :macruby => false) do
     m.times do |i|
       Struct.new("Contact#{i}", :first_name, :last_name, :home_number, :cell_number, :email )
     end
   end

  lrz      = Contact.new('Laurent', 'Sansonetti', '123-456-5555', '555-444-3333', 'lrz@gmail.com')
  matt     = Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
  
  
  x.bench("==\n") do
     n.times do
       matt == lrz
     end
   end
  
   x.bench("eql?\n") do
      n.times do
        matt.eql?(lrz)
      end
    end
    
  x.bench("new instance\n") do
     n.times do
       Contact.new('Matt', 'Aimonetti', '858-555-5555', '555-444-3333', 'mattaimonetti@gmail.com')
     end
   end 
   
  
  x.bench("attribute reference by string\n") do
     o.times{ matt['home_number'] }
  end 
  x.bench("attribute reference by symbol\n") do
     o.times{ matt[:home_number] }
  end
  x.bench("attribute reference by index\n") do
     o.times{ matt[2] }
  end
  x.bench("each {|obj| block }\n") do
     o.times{ matt.each{|x| x} }
  end
  x.bench("each_pair {|sym, obj| block }\n") do
     o.times{ matt.each_pair{|name, value| name} }
  end 
  x.bench("length\n") do
     o.times{ matt.length }
  end
  x.bench("members\n") do
     o.times{ matt.members }
  end
  x.bench("select{|i| block}\n") do
     o.times{ matt.select{|i| true} }
  end 
  x.bench("values_at(indexes)}\n") do
     o.times{ matt.values_at(1,3) }
  end
  x.bench("values_at(negative indexes)}\n") do
     o.times{ matt.values_at(-1,-3) }
  end 
  x.bench("values_at(ranges)}\n") do
     o.times{ matt.values_at(1..3, 2...5) }
  end


  
  x.bench("hash\n") do
     n.times{ matt.hash }
  end
  x.bench("to_s\n") do
     n.times{ matt.to_s }
  end
  x.bench("to_a\n") do
   n.times{ matt.to_a } 
  end 
  
end