
This project is about a specific topic of the **Gowin GW5A FPGAs**, 
especially the `GW5A-LV25MG121NES` chip which is used in the Sipeed `Tang Primer 25K` development board,
and the way the internal Analog-Digital Converter (ADC) may be used to read external analog signals.
The examples here use the Verilog HDL.

Reason behind:

Though having quick success with the basic programming of the FPGA, I had no luck finding any examples about how to access its built-in ADC converter to measure external analog signals; it seems the ADC is primarily intended to measure the chip's internal temperature, and core and I/O voltages; and there is also quite likely an error (`USE_ADC_SRC_bus0 loc` vs. `USE_ADC_SRC bus0 loc`) in the documentation.

So after finally getting something to work, I'm eager to publish my results here.


About the environment:

This project uses Gowin's EDA Software ('Gowin FPGA Designer') in version 1.9.9.02 which you need for the IP.
The software can be downloaded, after registration, free of charge, from their webpage and will be licensed to your PC.
One major issue (if i'm not mistaken) with the software is, that it does not include a verilog ***simulator***; which is serious.
However, one can use the relatively quick download to the board and the real-time back-transmitting of selected signals values
which are displayed in the EDA software like in an logic analyzer; which works quite good for me. 
One might even argue that testing in the real hardware is superior to simulation.

The `Sipeed Tang Primer 25K` development board can be bought on amazon for around 45€.
It comes with an internal USB/JTAG bridge, so connecting to a (Windows) PC is plug and play.

*Disclaimer: In no way I want to recommend Gowin over other (bigger) FPGA suppliers. I just stumbled across the board and gave it a try; and so far it works. You should also be aware, that Gowin is a chinese company.*


Back to the show:

I got three slightly different approaches to work.

Therefore there are three independent FPGA projects in this repository. 
Yes, it would have been possible to merge them into one, and I tried, but it went clumsy with some conditional compilation statements and actions to be performed in the EDA software.
So I sticked to separate folders named 'Mode_0' to 'Mode_2'.

1. The first, named `Mode 0` just activates the ADC and continuously reads values from one input channel 
( in the example the signal IOT56, which is bound to pins J8/K8 (pins 36 and 35 on the 40 pin adapter) of the Tang Primer 25K development board ).
Note, that the ADC always expects differential signals, so you have a positive and a negative part;
in my understanding it's completly okay to just tie the negative part of the signal (K8 / Pin 35) to GND.
Also note that the measurement range is only around one volt.
    <table>
    <tr><th>Channel</th><th>Id.</th><th>Name</th><th>Bank</th><th>PMOD</th><th>Pin at 40pin</th></tr>
    <tr><th>0</th><th>Signal J8</th><th>IOT56A</th><th>1</th><th></th><th>5</th></tr>
    <tr><th> </th><th>Signal K8</th><th>IOT56B</th><th>1</th><th></th><th>6</th></tr>
    </table>


2. The second example, `Mode 1`, allows to multiplex exactly two external analog input signals to the ADC.
It relies on the trick (?) to use the two `VSENCTL` modes `GLO_LEFT` and `GLO_RIGHT` to swap inputs.
Here, in addition to the signal IOT56 from the above example, the signal IOT26 (F2/F1, pins 16 and 15 on the 40 pin connector) is used as the second analog input. 
    <table>
    <tr><th>Channel</th><th>Id.</th><th>Name</th><th>Bank</th><th>PMOD</th><th>Pin at 40pin</th></tr>
    <tr><th>0</th><th>Signal J8</th><th>IOT56A</th><th>1</th><th></th><th>5</th></tr>
    <tr><th> </th><th>Signal K8</th><th>IOT56B</th><th>1</th><th></th><th>6</th></tr>
    <tr><th>1</th><th>Signal F2</th><th>IOT26A</th><th>1</th><th></th><th>25</th></tr>
    <tr><th> </th><th>Signal F1</th><th>IOT26B</th><th>1</th><th></th><th>26</th></tr>
    </table>

3. The last repository, `Mode 2`, allows to multiplex up to five external analog input signals to the ADC.
It relies on changing the 'tlvds_ibuf_adc_*' arguments while 'VSENCTL' stays fixed in 'LOC_LEFT' mode.
This is the most versatile mode, but requires a bit more code, and limits the analog inputs to `BANK 1`.
The example uses the following signals/pins. They are all available on PMOD (not the 40 pin), connectors.
    <table>
    <tr><th>Channel</th><th>Id.</th><th>Name</th><th>Bank</th><th>PMOD</th><th>Pin at PMOD</th></tr>
    <tr><th>0</th><th>Signal H5</th><th>IOT61A</th><th>1</th><th>0 / J6</th><th>5</th></tr>
    <tr><th> </th><th>Signal J5</th><th>IOT61B</th><th>1</th><th>0 / J6</th><th>6</th></tr>
    <tr><th>1</th><th>Signal L5</th><th>IOT63A</th><th>1</th><th>1 / J5</th><th>5</th></tr>
    <tr><th> </th><th>Signal K5</th><th>IOT63B</th><th>1</th><th>1 / J5</th><th>6</th></tr>
    <tr><th>2</th><th>Signal H8</th><th>IOT66A</th><th>1</th><th>0 / J6</th><th>7</th></tr>
    <tr><th> </th><th>Signal H7</th><th>IOT66B</th><th>1</th><th>0 / J6</th><th>8</th></tr>
    <tr><th>3</th><th>Signal G7</th><th>IOT68A</th><th>1</th><th>0 / J6</th><th>9</th></tr>
    <tr><th> </th><th>Signal G8</th><th>IOT68B</th><th>1</th><th>0 / J6</th><th>10</th></tr>
    <tr><th>4</th><th>Signal F5</th><th>IOT72A</th><th>1</th><th>0 / J6</th><th>11</th></tr>
    <tr><th> </th><th>Signal G5</th><th>IOT72B</th><th>1</th><th>0 / J6</th><th>12</th></tr>
    </table>


Some notes to get it running:

* If it's just to see whether it works with your hardware, before to bother with compiling the project sources, you may download the `bitstream` file `ao_0.fs` in the `impl - pnr` subdirectory. 
* In every of the above Gowin EDA projects, in 'Project - Configuration - Dual-Purpose-Pins' the `READY`, `DONE` and `CPU` boxes have to be checked; otherwise you'll get some strange error messages.
* The example folders contain `.rao` files; these are configurations for the EDA software's built in logic-analyzer (they call it 'Analyzer Oscilloscope'). Those configurations are used when the 'Analyzer Oscilloscope' is started from within the EDA software, it features an integrated hardware download and then allows to monitor the things going on in the FPGA in real-time.


A few other notes:

* The official Gowin manual for the ADC : UG299E-ADC, I used version 1.0.3E dated 2024-02-02.
* The examples here deal with the Gowin GW5A-25 FPGA which has one ADC; in his chip family there are also various -75 and -138 members, which have two ADCs. I have not worked with those. According to the (above) manual, it looks pretty similar.


As I'm new to posting here, tks to all advices.

Have fun, Robert
