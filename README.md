# Calculator

## Memory Calculator
This calculator has the ability to add or subtract two two digit decimal numbers.
The numerical results are displayed on two seven segments displays and the sign and overflow flag
are displayed using an RGB LED.

The instructions to the calculater can be found [here](/docs/manual.pdf).

## Pin Layout
**Input/Ouput (IO) of Integrated Circuit (IC)**:

System Signals :
`clk` : 10 MHz clock
`nrst` : active low system reset

Inputs :
`push buttons (1, 0)` : binary inputs to the calculator
`add`, `subtract` inputs (opcodes)
`reg [1-4]` : four register values to tell where to store digit input or where to read from.

Outputs :
`segs[0-13]` : 14 segments to show the digit outputs
`neg` : signals whether the output or inputs are negative values
`overflow`: signals if the numbers caused a overflow


<p align="center">
  <img src="/img/io.png" alt="Chip IO" width="900" height="auto"/>
</p>
