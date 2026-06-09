This is the Verilog code of a digital clock in 12 hour time standard (am/pm). There are both behavioural and structural versions of it.

In the behavioural version, it just states when the registers  have to increment and when to rollover back. The whole circuit is synchronous.

In the structural version, it uses mod 16 counters, mod 2 counters with different reset value and a mod 10 counter with a fixed parallel load option too. The complete circuit is synchronous i.e. the output of counter hasn't been put in the clock of other counter. Rather, it uses logic functions, enable option and reset option to control when the counters should update and reset back.
