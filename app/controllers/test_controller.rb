class TestController < ApplicationController
  def index
    ticks_remaining = Integer(RESPONSE_TIME_SECONDS/TICK_RATE_SECONDS)

    until ticks_remaining == 0
      case rand(0.0..1.0)
      when (0.0..CPU_RATIO)
        cpu_spin(TICK_RATE_SECONDS)
      else
        sleep(TICK_RATE_SECONDS)
      end
      ticks_remaining -= 1
    end
    render plain: "ok!"
  end

  private

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
end
