# hold these constant future experiments can change them
response_time = 0.5
tick_rate = 0.01
cpu_ratio = 0.25

command = "hey -o csv --disable-keepalive -c 32 -n 500 \"http://localhost:8080?rt=%{rt}&tr=%{tr}&cpu=%{cpu}&bg_t=%{bg_t}&bg_s=%{bg_s}\" > bench_out/%{out}.csv"

# test length of background thread thread work while keeping total background thread work constant.
[0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10].each do |bg_time|
  bg_sleep = 0.01 + bg_time # TODO: does this keep total background thread time constant?

  cmd = command % { rt: response_time, tr: tick_rate, cpu: cpu_ratio, bg_t: bg_time, bg_s: bg_sleep, out: "out_#{bg_time}" }
  puts cmd
  system(cmd)
end

# require 'csv'
