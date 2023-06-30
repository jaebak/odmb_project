# Usage: vivado -nojournal -nolog -mode batch -source make_mcs.tcl -tclargs firmware.bit
set INFILE [lindex $argv 0]
set OUTFILE "${INFILE}.mcs"
write_cfgmem -format mcs -interface SPIx8 -size 32 -loadbit "up 0 $INFILE" -file "$OUTFILE"
