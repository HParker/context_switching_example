require 'csv'

[0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10].each do |bg_time|
  csv = CSV.read("bench_out/out_#{bg_time}.csv", headers: true)
  sum = 0.0
  count = csv.size
  csv.each { |r|
    time = r["response-time"].to_f
    sum += time
  }
  puts "bg_time %.2f did #{count} in %.2f seconds %.2f avg response time" % [bg_time, sum, sum/count]
  puts "%.2f, %.2f, %.2f" % [bg_time, sum, sum/count]
end
