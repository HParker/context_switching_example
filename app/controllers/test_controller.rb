class TestController < ApplicationController
  def index
    response_time = params[:rt].to_f
    tick_rate = params[:tr].to_f
    cpu_ratio = params[:cpu].to_f
    $bg_time = params[:bg_t].to_f
    $bg_sleep = params[:bg_s].to_f

    ticks_remaining = Integer(response_time/tick_rate)

    until ticks_remaining == 0
      case rand(0.0..1.0)
      when (0.0..cpu_ratio)
        cpu_spin(tick_rate)
      else
        sleep(tick_rate)
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
