# MIPS-CPU
Build a multiple cycles CPU of MIPS

R类指令：取指、译码、执行（ALU计算），完成（写回寄存器堆）。

I类ALU算术逻辑指令：取指、译码、执行（ALU），完成（写回寄存器堆）。

lw，sw：取指、译码、内存地址计算（ALU）、内存存取、写回（lw有，sw无）。

beq，bne：取指、译码、完成（完成跳转地址的计算和是否应该跳转）。

jump：取指、译码、完成（完成跳转地址的计算）。
