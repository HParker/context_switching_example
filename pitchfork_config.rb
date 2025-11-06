worker_processes 16

def cpu_spin(seconds)
  (seconds / CPU_LOOP_DURATION).ceil.times do
    fibonacci(FIB_DEPTH)
  end
end

def fibonacci(i)
  if i <= 1
    i
  else
    fibonacci(i - 1) + fibonacci(i - 2)
  end
end


after_worker_ready do |server, worker|
  t = Thread.new do
    loop do
      cpu_spin(BG_CPU_BLOCK_TIME)
      sleep(BG_SLEEP_TIME)
    end
  end
end
