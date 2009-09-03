require 'benchmark' 

n = 4_000
o = 10_000
p = 50_000
Benchmark.bm do |b|
  small_origin = File.open('fixtures/jules.txt')
  large_origin = File.open('fixtures/verne.txt')

   b.report("new\n") do
     p.times do
      IO.new( 1, "w" )
     end
   end 

  if IO.respond_to?(:binread)
    b.report("binread\n") do
       n.times do
         IO.binread('fixtures/verne.txt')
       end
     end
   end 
   
   b.report("copy_stream (small file)\n") do
     n.times do
       IO.copy_stream('fixtures/jules.txt', 'fixtures/tmp', 10, 10)
     end
   end
    
   b.report("copy_stream (big file)\n") do
     n.times do
       IO.copy_stream('fixtures/verne.txt', 'fixtures/tmp', 40, 40)
     end
   end
      
   destination = File.open('fixtures/tmp', 'w+')
   # not running on MacRuby atm
   # b.report("copy_stream using IO sources (small file)\n") do
   #   n.times do
   #     IO.copy_stream(small_origin, destination, 10, 10)
   #   end
   # end  
       
   # b.report("copy_stream using IO sources (big file)\n") do
   #   n.times do
   #     IO.copy_stream(large_origin, destination, 40, 40)
   #   end
   # end

   b.report("foreach (small file)\n") do
     o.times do
       IO.foreach('fixtures/jules.txt'){|x| x }
     end
   end 
   
   
   b.report("foreach (large file)\n") do
     100.times do
       IO.foreach('fixtures/verne.txt'){|x| x }
     end
   end 

   b.report("open\n") do
     p.times do |i|
       IO.open(1, "w"){|io| }
     end
   end 

   b.report("pipe\n") do
     25_000.times do |i|
       rd, wr = IO.pipe
       rd.close
       wr.close 
     end
   end    
   
   b.report("popen\n") do
     150.times do |i|
       IO.popen("uname")
     end
   end 
   
   ObjectSpace.each_object(IO) {|x| x.close unless (x.closed? || x.inspect =~ /STD|fixtures/i) }

   b.report("read (small file)\n") do
     n.times do
       IO.read('fixtures/jules.txt')
     end
   end 

   b.report("read (big file)\n") do
     o.times do
       IO.read('fixtures/verne.txt', 1_000)
     end
   end

   b.report("readlines (small file)\n") do
     o.times do
       IO.readlines('fixtures/jules.txt')
     end
   end

   b.report("readlines (large file)\n") do
     150.times do
       IO.readlines('fixtures/verne.txt')
     end
   end

   b.report("sysopen (small file)\n") do
     n.times do
       IO.sysopen('fixtures/jules.txt')
     end
   end
   
   ObjectSpace.each_object(IO) {|x| x.close unless (x.closed? || x.inspect =~ /STD|fixtures/i) }   
  
   b.report("sysopen (large file)\n") do
     3_000.times do
       IO.sysopen('fixtures/verne.txt')
     end
   end

   ObjectSpace.each_object(IO) {|x| x.close unless (x.closed? || x.inspect =~ /STD|fixtures/i) }   
   
   class DummyIO; def to_io; STDOUT; end; end
   dio = DummyIO.new
   b.report("try_convert obj\n") do
     p.times do
       IO.try_convert(dio)
     end
   end
    
   b.report("try_convert str\n") do
     p.times do
       IO.try_convert("dio")
     end
   end

   b.report("<<\n") do
     100_000.times do
       STDOUT << ""
     end
   end
   
   b.report("binmode\n") do
     10_000.times do
       i = IO.new(1); i.binmode;
     end
   end 

   b.report("binmode?\n") do
     200_000.times do
       small_origin.binmode?
     end
   end
   
   b.report("chars (small file)\n") do
     p.times do
      small_origin.chars
     end
   end 
 
   b.report("chars (large file)\n") do
     p.times do
      large_origin.chars
     end
   end
            
   small_origin.close
   large_origin.close
   destination.close   
   
end