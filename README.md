# Modified-Round_Robin_algorithm-using-verilog
This project implements a 4-request Round Robin Arbiter using Verilog HDL. The arbiter is designed to fairly allocate access to a shared resource among multiple requesters by using a rotating priority mechanism.
Unlike fixed-priority arbiters, the Round Robin algorithm ensures that every requester eventually receives service, thereby preventing starvation.

The design is implemented using D Flip-Flops to rotate the priority token, and the functionality is verified through simulation using Xilinx ISE and its ISim simulator.
