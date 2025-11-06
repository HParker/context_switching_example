* Test of effect on performance of thread context switching

Question: How much does context swiching effect performance in a mulitprocess application with background threads that need to do some specific amount of (CPU) work?

Multiprocess: Multiprocess is important because reducing context switching between threads could free CPU cores for other processes instead of other process subthreads.
Multithread: Multithread is important because it allows CPU work to be done during main thread IO.

The tradeoff: having multiple threads doing work means more context switching which has a cost, but allows lower latency.

Core question: What is the point where context switching to reduce latency adds too much overhead?

** Setup

Rails app, with background thread that does silly CPU work (fibanacci N)

Nobs we want to be able to turn
* length of each background thread work
* frequency of background thread work
* Total background CPU work
* Number of webworkers
* mainthread IO time
* mainthread IO frequency
* Number of available cores
* Total request time

See config.ru for configuration variables