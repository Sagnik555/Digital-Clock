This is the Verilog code for a digital clock in the 12-hour time format (am/pm). There are both behavioral and structural versions of it.

In the behavioral version, it just states when the registers  have to increment and when to rollover back. The whole circuit is synchronous.

In the structural version, it uses mod-16 counters, mod-2 counters with different reset values, and a mod-10 counter with a fixed parallel load option. The entire circuit is synchronous, i.e., the counter's output isn't fed into the other counter's clock. Rather, it uses logic functions, enable option and reset option to control when the counters should update and reset.
