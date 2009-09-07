require File.expand_path('herbs_helper') 

n = 4_000
o = 10_000
p = 50_000

def clear_ios
  ObjectSpace.each_object(IO) {|x| x.close unless (x.closed? || x.inspect =~ /STD|fixtures/i) }   
end

Benchmark.bm do |b|
  small_origin = File.open('fixtures/jules.txt')
  large_origin = File.open('fixtures/verne.txt')

   b.bench("new\n", :macruby => false) do
     p.times do
      IO.new( 1, "w" )
     end
   end   

  if IO.respond_to?(:binread)
    b.bench("binread\n") do
       n.times do
         IO.binread('fixtures/verne.txt')
       end
     end
   end 
   
   b.bench("copy_stream (small file)\n", :macruby => false) do
     n.times do
       IO.copy_stream('fixtures/jules.txt', 'fixtures/tmp', 10, 10)
     end
   end
    
   b.bench("copy_stream (big file)\n", :macruby => false) do
     n.times do
       IO.copy_stream('fixtures/verne.txt', 'fixtures/tmp', 40, 40)
     end
   end
      
   destination = File.open('fixtures/tmp', 'w+')
   # not running on MacRuby atm
   b.bench("copy_stream using IO sources (small file)\n", :macruby => false) do
     n.times do
       IO.copy_stream(small_origin, destination, 10, 10)
     end
   end  
       
   b.bench("copy_stream using IO sources (big file)\n", :macruby => false) do
     n.times do
       IO.copy_stream(large_origin, destination, 40, 40)
     end
   end  

   b.bench("foreach (small file)\n") do
     o.times do
       IO.foreach('fixtures/jules.txt'){|x| x }
     end
   end 
   
   
   b.bench("foreach (large file)\n") do
     100.times do
       IO.foreach('fixtures/verne.txt'){|x| x }
     end
   end 

   b.bench("open\n", :macruby => false) do
     p.times do |i|
       IO.open(1, "w"){|io| }
     end
   end 

   b.bench("pipe\n") do
     25_000.times do |i|
       rd, wr = IO.pipe
       rd.close
       wr.close 
     end
   end    

   clear_ios
   
   b.bench("popen\n") do
     150.times do |i|
       IO.popen("uname")
     end
   end   
   
   clear_ios

   b.bench("read (small file)\n") do
     n.times do
       IO.read('fixtures/jules.txt')
     end
   end 

   b.bench("read (big file)\n") do
     o.times do
       IO.read('fixtures/verne.txt', 1_000)
     end
   end

   b.bench("readlines (small file)\n") do
     o.times do
       IO.readlines('fixtures/jules.txt')
     end
   end

   b.bench("readlines (large file)\n") do
     150.times do
       IO.readlines('fixtures/verne.txt')
     end
   end
   
   clear_ios

   # b.bench("sysopen (small file) & close\n") do
   #   250.times do
   #     IO.sysopen('fixtures/jules.txt')
   #   end
   # end
   # 
   # ObjectSpace.each_object(IO) {|x| x.close unless (x.closed? || x.inspect =~ /STD/i) }   
   #   
   # b.bench("sysopen (large file)\n") do
   #   150.times do |n|
   #     IO.sysopen('fixtures/verne.txt')
   #   end
   # end  
   # 
   # clear_ios  
   
   class DummyIO; def to_io; STDOUT; end; end
   dio = DummyIO.new
   b.bench("try_convert obj\n") do
     p.times do
       IO.try_convert(dio)
     end
   end
    
   b.bench("try_convert str\n") do
     p.times do
       IO.try_convert("dio")
     end
   end

   b.bench("<<\n") do
     100_000.times do
       STDOUT << ""
     end
   end
   
   b.bench("binmode\n") do
     10_000.times do
       i = IO.new(1); i.binmode;
     end
   end 

   b.bench("binmode?\n", :macruby => false) do
     200_000.times do
       small_origin.binmode?
     end
   end  
   
   b.bench("chars (small file)\n") do
     p.times do
      small_origin.chars
     end
   end 
 
   b.bench("chars (large file)\n") do
     p.times do
      large_origin.chars
     end
   end
            
   small_origin.close
   large_origin.close
   destination.close   
   
end