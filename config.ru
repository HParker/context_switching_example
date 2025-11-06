# Main thread Config
IO_WAIT_RATIO = Float(ENV.fetch("IO_WAIT_RATIO") { 0.25 })
CPU_RATIO = 1.0 - IO_WAIT_RATIO
RESPONSE_TIME_SECONDS = Float(ENV.fetch("RESPONSE_TIME_SECONDS") { 0.25 })
TICK_RATE_SECONDS = Float(ENV.fetch("TICK_RATE_SECONDS") { 0.01 })

# Background thread config
BG_CPU_BLOCK_TIME = Float(ENV.fetch("BG_CPU_BLOCK_TIME") { 0.011 })
BG_SLEEP_TIME = Float(ENV.fetch("BG_SLEEP_TIME") { 0.01 }) # 5 per request default

# puts "Testing with:"
# puts "#{CPU_RATIO * 100}% time spent waiting on CPU"
# puts "#{IO_WAIT_RATIO * 100}% time spent waiting on IO"
# puts "#{RESPONSE_TIME_SECONDS} seconds average response duration (approximate, not including GC)"
# puts "We will decide to do CPU or IO every #{TICK_RATE_SECONDS * 1000.0} milliseconds"
# puts "background thread block time: #{BG_CPU_BLOCK_TIME} sleep time: #{BG_SLEEP_TIME}"

def fibonacci(i)
  if i <= 1
    i
  else
    fibonacci(i - 1) + fibonacci(i - 2)
  end
end

require "benchmark"
FIB_DEPTH = 15
# We compute how long our loop take without thread preemption nor GC, so we can
# perform a constant amount of work every time.
# Another solution could be to use CLOCK_THREAD_CPUTIME_ID, but it include MRI's spurious
# check so it's quite accurate enough.
CPU_LOOP_DURATION = (100.times.map { Benchmark.realtime { fibonacci(FIB_DEPTH) } })[49]
if CPU_LOOP_DURATION > (TICK_RATE_SECONDS / 5)
  abort "CPU_LOOP_DURATION is too large for TICK_RATE_SECONDS"
end
puts "CPU iteration: #{CPU_LOOP_DURATION * 1_000.0}ms"

def cpu_spin(seconds)
  (seconds / CPU_LOOP_DURATION).ceil.times do
    fibonacci(FIB_DEPTH)
  end
end

# This file is used by Rack-based servers to start the application.
require_relative "config/environment"

run Rails.application
Rails.application.load_server
