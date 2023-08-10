-------------------------------------------------------
--! @file
--! @brief top level file for ODMB7 prototype firmware
-------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

--use work.ucsb_types.all;

--! @brief ODMB7 prototype firmware
--! @details ODMB7 firmware. Currently capable of testing virtually all 
--! hardware interfaces and performing most slow control functionality, however
--! data acquisition firmware has not yet been developed
entity odmb7_ucsb_dev is
  port (
    --------------------
    -- Input clocks
    --------------------
    CMS_CLK_FPGA_P : in std_logic;                         --! CMS/system clock: 40.07897 MHz. Can be from local oscillator or CCB. Used to generate most clocks used in firmware. Connected to bank 45.
    CMS_CLK_FPGA_N : in std_logic;                         --! CMS/system clock: 40.07897 MHz. Can be from local oscillator or CCB. Used to generate most clocks used in firmware. Connected to bank 45.
    GP_CLK_6_P     : in std_logic;                         --! From clock synthesizer ODIV6: 80 MHz. Currently unused. Connected to bank 44.
    GP_CLK_6_N     : in std_logic;                         --! From clock synthesizer ODIV6: 80 MHz. Currently unused. Connected to bank 44.
    GP_CLK_7_P     : in std_logic;                         --! From clock synthesizer ODIV7: 80 MHz. Currently unused. Connected to bank 68.
    GP_CLK_7_N     : in std_logic;                         --! From clock synthesizer ODIV7: 80 MHz. Currently unused. Connected to bank 68.
    REF_CLK_1_P    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 224.
    REF_CLK_1_N    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 224.
    REF_CLK_2_P    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 227.
    REF_CLK_2_N    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 227.
    REF_CLK_3_P    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 226.
    REF_CLK_3_N    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 226.
    REF_CLK_4_P    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 225.
    REF_CLK_4_N    : in std_logic;                         --! From clock synthesizer, refclk0 to GTH quad 225.
    REF_CLK_5_P    : in std_logic;                         --! From clock synthesizer, refclk1 to GTH quad 227.
    REF_CLK_5_N    : in std_logic;                         --! From clock synthesizer, refclk1 to GTH quad 227.
    CLK_125_REF_P  : in std_logic;                         --! From clock synthesizer, refclk1 to GTH quad 226.
    CLK_125_REF_N  : in std_logic;                         --! From clock synthesizer, refclk1 to GTH quad 226.
    LF_CLK         : in std_logic;                         --! From clock synthesizer, 10 kHz. General purpose low frequency clock, currently unused. Connected to bank 45.

    --------------------
    -- Signals controlled by ODMB_VME
    --------------------
    -- From/To VME controller to/from MBV
    VME_DATA        : inout std_logic_vector(15 downto 0); --! Data to/from VME backplane. Used by ODMB_VME module. Connected to bank 48.
    VME_GAP_B       : in std_logic;                        --! Geographical address (VME slot) parity. Used by ODMB_VME module. Connected to bank 48.
    VME_GA_B        : in std_logic_vector(4 downto 0);     --! Geographical address (VME slot). Used by ODMB_VME and ODMB CTRL module. Connected to bank 48.
    VME_ADDR        : in std_logic_vector(23 downto 1);    --! VME address (command). Used by ODMB_VME module. Conencted to bank 46.
    VME_AM          : in std_logic_vector(5 downto 0);     --! VME address modifier. Used by ODMB_VME module. Connected to cank 46.
    VME_AS_B        : in std_logic;                        --! VME address strobe. Used by ODMB_VME module. Connected to bank 46.
    VME_DS_B        : in std_logic_vector(1 downto 0);     --! VME data strobe. Used by ODMB_VME module. Connected to bank 46.
    VME_LWORD_B     : in std_logic;                        --! VME data word length. Used by ODMB_VME module. Connected to bank 48.
    VME_WRITE_B     : in std_logic;                        --! VME write/read indicator. Used by ODMB_VME module. Connected to bank 48.
    VME_IACK_B      : in std_logic;                        --! VME interrupt acknowledge. Used by ODMB_VME module. Connected to bank 48.
    VME_BERR_B      : in std_logic;                        --! VME bus error indicator. Used by ODMB_VME module. Connected to bank 48.
    VME_SYSRST_B    : in std_logic;                        --! VME system reset. Not used. Connected to bank 48.
    VME_SYSFAIL_B   : in std_logic;                        --! VME system failure indicator. Used by ODMB_VME module. Connected to bank 48.
    VME_CLK_B       : in std_logic;                        --! VME clock. Not used. Connected to bank 48.
    KUS_VME_OE_B    : out std_logic;                       --! VME output enable. Controlled by ODMB_VME module. Connected to bank 44.
    KUS_VME_DIR     : out std_logic;                       --! ODMB board VME input/output direction. Controlled by ODMB_VME module. Connected to bank 44.
    VME_DTACK_KUS_B : out std_logic;                       --! VME data acknowledge. Controlled by ODMB_VME module. Connected to bank 44.

    -- From/To PPIB (connectors J3 and J4)
    DCFEB_TCK_P    : out std_logic_vector(7 downto 1);     --! (x)DCFEB JTAG TCK signal. One per (x)DCFEB. Used by ODMB_VME module. Connected to bank 68.
    DCFEB_TCK_N    : out std_logic_vector(7 downto 1);     --! (x)DCFEB JTAG TCK signal. One per (x)DCFEB. Used by ODMB_VME module. Connected to bank 68. 
    DCFEB_TMS_P    : out std_logic;                        --! (x)DCFEB JTAG TMS signal. Used by ODMB_VME module. Connected to bank 68.
    DCFEB_TMS_N    : out std_logic;                        --! (x)DCFEB JTAG TMS signal. Used by ODMB_VME module. Connected to bank 68.
    DCFEB_TDI_P    : out std_logic;                        --! (x)DCFEB JTAG TDI signal. Used by ODMB_VME module. Connected to bank 68.
    DCFEB_TDI_N    : out std_logic;                        --! (x)DCFEB JTAG TDI signal. Used by ODMB_VME module. Connected to bank 68.
    DCFEB_TDO_P    : in  std_logic_vector(7 downto 1);     --! (x)DCFEB JTAG TDO signal. One per (x)DCFEB. Used by ODMB_VME module. Connected to bank 67-68 as "C_TDO".
    DCFEB_TDO_N    : in  std_logic_vector(7 downto 1);     --! (x)DCFEB JTAG TDO signal. One per (x)DCFEB. Used by ODMB_VME module. Connected to bank 67-68 as "C_TDO". 
    DCFEB_DONE     : in  std_logic_vector(7 downto 1);     --! (x)DCFEB programming done signal. Used only by top level DCFEB startup process. Connected to bank 68 as "DONE_*".
    RESYNC_P       : out std_logic;                        --! (x)DCFEB resync signal. Used by ODMB_VME module. Connected to bank 66.
    RESYNC_N       : out std_logic;                        --! (x)DCFEB resync signal. Used by ODMB_VME module. Connected to bank 66.
    BC0_P          : out std_logic;                        --! (x)DCFEB bunch crossing 0 synchronization signal. Initiated by CCB_BX0 signal or from ODMB_VME. Connected to bank 68.
    BC0_N          : out std_logic;                        --! (x)DCFEB bunch crossing 0 synchronization signal. Initiated by CCB_BX0 signal or from ODMB_VME. Connected to bank 68.
    INJPLS_P       : out std_logic;                        --! Calibration INJPLS signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    INJPLS_N       : out std_logic;                        --! Calibration INJPLS signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    EXTPLS_P       : out std_logic;                        --! Calibration EXTPLS signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    EXTPLS_N       : out std_logic;                        --! Calibration EXTPLS signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    L1A_P          : out std_logic;                        --! Trigger L1A signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    L1A_N          : out std_logic;                        --! Trigger L1A signal for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    L1A_MATCH_P    : out std_logic_vector(7 downto 1);     --! L1A match for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    L1A_MATCH_N    : out std_logic_vector(7 downto 1);     --! L1A match for (x)DCFEBs. From ODMB CTRL module. Connected to bank 66.
    PPIB_OUT_EN_B  : out std_logic;                        --! PPIB output enable signal. Should be fixed to '0'. Connected to bank 68.
    DCFEB_REPROG_B : out std_logic;                        --! (x)DCFEB reprogram signal. From ODMBCTRL in ODMB_VME module. Connected to bank 68.

    --------------------
    -- CCB Signals
    --------------------
    CCB_CMD        : in  std_logic_vector(5 downto 0);     --! Command from CCB, generates BC0, L1ARST, etc. for ODMB. Used by ODMB CTRL module. Connected to bank 44.
    CCB_CMD_S      : in  std_logic;                        --! CCB command strobe. Used by ODMB CTRL module. Connected to bank 46.
    CCB_DATA       : in  std_logic_vector(7 downto 0);     --! CCB data. Only used in CCB communication test. Connected to bank 44.
    CCB_DATA_S     : in  std_logic;                        --! CCB data strobe. Only used in CCB communication test. Connected to bank 46.
    CCB_CAL        : in  std_logic_vector(2 downto 0);     --! CCB calibration signals. Only used in CCB communication test. In ODMB2014 fw, connected to ODMB CTRL but unused. Connected to bank 44.
    CCB_CRSV       : in  std_logic_vector(3 downto 0);     --! CCB CCB-reserved signals. Only used in CCB communication test. In ODMB2014 fw, connected to ODMB CTRL but unused. Connected to bank 44.
    CCB_DRSV       : in  std_logic_vector(1 downto 0);     --! CCB DMB-reserved signals. Only used in CCB communication test. In ODMB2014 fw, connected to ODMB CTRL but unused. Connected to bank 45.
    CCB_RSVO       : in  std_logic_vector(4 downto 0);     --! CCB DMB-reserved output. Only used in CCB communication test. In ODMB2014 fw, connected to ODMB CTRL but unused. Connected to bank 45.
    CCB_RSVI       : out std_logic_vector(2 downto 0);     --! CCB DMB-reserved input. Only used in CCB communication test. In ODMB2014 fw, connected to ODMB CTRL but unused. Connected to bank 45.
    CCB_BX0_B      : in  std_logic;                        --! CCB bunch-crossing 0 synchronization signal. Used to generate BC0 pulse to (x)DCFEBs. Connected to Bank 46 as "CCB_BX0".
    CCB_BX_RST_B   : in  std_logic;                        --! CCB bunch-crossing reset signal. Used by ODMB CTRL. Connected to bank 46 as "CCB_BX_RST".
    CCB_L1A_RST_B  : in  std_logic;                        --! CCB L1A reset signal. Used by simulated FE boards but not ODMB CTRL in ODMB2014 fw. Connected to bank 46 as "CCB_L1A_RST".
    CCB_L1A_B      : in  std_logic;                        --! CCB L1A signal. Used to generate raw_l1a to ODMB CTRL in ODMB2014 fw. Connected to bank 46 as "CCB_L1A".
    CCB_L1A_RLS    : out std_logic;                        --! CCB L1A release. Fixed to '0' in ODMB2014 fw. Connected to bank 45.
    CCB_CLKEN      : in  std_logic;                        --! CCB clock enable signal. Connected to ODMB CTRL in ODMB2014 fw but unused. Connected to bank 46.
    CCB_EVCNTRES_B : in  std_logic;                        --! CCB event counter reset. Used by simulated FE boards. Connected to bank 64 as "CCB_EVCNTRES".
    CCB_HARDRST_B  : in  std_logic;                        --! CCB hard reset. Unusable since hard reset resets the FPGA but must be input to avoid self-reset. Connected to bank 45 in error.
    CCB_SOFT_RST_B : in  std_logic;                        --! CCB soft reset. Triggers reset of elements throughout firmware. Connected to bank 45 as "CCB_SOFT_RST".

    --------------------
    -- LVMB Signals
    --------------------
    LVMB_PON     : out std_logic_vector(7 downto 0);       --! Signal to LVMB to power on (x)DCFEBs and ALCT. Mapping of bits to boards is chamber dependent. Used by ODMB_VME. Connected to bank 67.
    PON_LOAD_B   : out std_logic;                          --! Signal to write LVMB_PON to LVMB. Used by ODMB_VME. Connected to bank 67.
    PON_OE       : out std_logic;                          --! Output enable for LVMB_PON. Fixed to '1'. Used by ODMB_VME. Connected to bank 67.
    MON_LVMB_PON : in  std_logic_vector(7 downto 0);       --! Signal to check (x)DCFEBs and ALCT power status from LVMB. Mapping of bits to boards is chamber dependent. Used by ODMB_VME. Connected to bank 67.
    LVMB_CSB     : out std_logic_vector(6 downto 0);       --! LVMB ADC SPI chip select. Used by ODMB_VME. Connected to bank 67.
    LVMB_SCLK    : out std_logic;                          --! LVMB ADC SPI clock. Used by ODMB_VME. Connected to bank 68.
    LVMB_SDIN    : out std_logic;                          --! LVMB ADC SPI input. Used by ODMB_VME. Connected to bank 68.
    LVMB_SDOUT_P : in std_logic;                           --! LVMB ADC SPI output. Used by ODMB_VME. Connected to bank 67 as C_LVMB_SDOUT_P.
    LVMB_SDOUT_N : in std_logic;                           --! LVMB ADC SPI output. Used by ODMB_VME. Connected to bank 67 as C_LVMB_SDOUT_N.

    --------------------------------
    -- OTMB communication signals
    --------------------------------
    OTMB            : in  std_logic_vector(35 downto 0);   --! OTMB data. Used for packet building and PRBS test. Connected to bank 44-45 as "TMB[35:0]".
    RAWLCT          : in  std_logic_vector(7 downto 0);    --! Local charged track signals, used by TRGCNTRL in ODMB CTRL for timing and for PRBS test. Connected to bank 45 (to be updated).
    OTMB_DAV        : in  std_logic;                       --! OTMB data available used by TRGCNTRL in ODMB CTRL for timing. Connected to bank 45 as TMB_DAV.
    LEGACY_ALCT_DAV : in  std_logic;                       --! ALCT data available used by TRGCNTRL in ODMB CTRL for timing. Connected to bank 45 as RSVTD[7] (to be updated).
    OTMB_FF_CLK     : in  std_logic;                       --! Unused. Connected to bank 45 as TMB_FF_CLK.
    RSVTD           : in  std_logic_vector(5 downto 3);    --! Reserved to DMB signals used only for OTMB PRBS test. Connected to bank 44-45 as RSVTD[7:3] (to be updated).
    RSVFD           : out std_logic_vector(3 downto 1);    --! Reserved to DMB signals used to send L1A info to OTMB and for PRBS test. Connected to bank 44-45 as RSVTD[2:0] (to be updated).
    LCT_RQST        : out std_logic_vector(2 downto 1);    --! Used to send LCT and external trigger requests generated by ODMB_VME and for PRBS test. Connected to bank 45.

    --------------------------------
    -- ODMB JTAG
    --------------------------------
    KUS_TMS       : out std_logic;                         --! JTAG TMS signal to ODMB FPGA, used by ODMBJTAG in ODMB_VME. Connected to bank 47.
    KUS_TCK       : out std_logic;                         --! JTAG TCK signal to ODMB FPGA, used by ODMBJTAG in ODMB_VME. Connected to bank 47.
    KUS_TDI       : out std_logic;                         --! JTAG TDI signal to ODMB FPGA, used by ODMBJTAG in ODMB_VME. Connected to bank 47.
    KUS_TDO       : in std_logic;                          --! JTAG TDO signal from ODMB FPGA, used by ODMBJTAG in ODMB_VME. Connected to bank 47 as TDO (pin U9).
    KUS_DL_SEL    : out std_logic;                         --! ODMB JTAG path select, connected to ODMBJTAG module in ODMB_VME. Use 1 for DL/red box and 0 for firmware communication. Connected to bank 47.

    --------------------------------
    -- ODMB optical ports
    --------------------------------
    -- Below are not needed because, they are defined by the location of the optics ipcore.
    --DAQ_RX_P     : in std_logic_vector(10 downto 0);       --! R12 optical RX from FE boards.
    --DAQ_RX_N     : in std_logic_vector(10 downto 0);       --! R12 optical RX from FE boards.
    --DAQ_SPY_RX_P : in std_logic;                           --! R12 optical RX from FE boards (DAQ_RX_P11) or finisar RX SPY_RX_P.
    --DAQ_SPY_RX_N : in std_logic;                           --! R12 optical RX from FE boards (DAQ_RX_N11) or finisar RX SPY_RX_N.
    --B04_RX_P     : in std_logic_vector(4 downto 2);        --! B04 optical RX from FED. No use yet.
    --B04_RX_N     : in std_logic_vector(4 downto 2);        --! B04 optical RX from FED. No use yet.
    --BCK_PRS_P    : in std_logic;                           --! B04 optical RX from FED for backpressure (B04_RX1_P).
    --BCK_PRS_N    : in std_logic;                           --! B04 optical RX from FED for backpressure (B04_RX1_N).
    --SPY_TX_P     : out std_logic;                          --! Finisar (spy) optical TX output to PC.
    --SPY_TX_N     : out std_logic;                          --! Finisar (spy) optical TX output to PC.
    --DAQ_TX_P     : out std_logic_vector(2 downto 2);       --! B04 optical TX, output to FED.
    --DAQ_TX_N     : out std_logic_vector(2 downto 2);       --! B04 optical TX, output to FED.

    --------------------------------
    -- Optical control signals
    --------------------------------
    DAQ_SPY_SEL    : out std_logic;                        --! Multiplexor control. 0 to select DAQ_RX_P/N11, 1 to select SPY_RX_P/N.

    RX12_I2C_ENA   : out std_logic;                        --! I2C enable for RX12 firefly, currently tied to 0. Connected to bank 66.
    RX12_SDA       : inout std_logic;                      --! I2C serial data signal to/from RX12 firefly, currently unused. Connected to bank 66.
    RX12_SCL       : inout std_logic;                      --! I2C serial clock signal to RX12 firefly, currently unused. Connected to bank 66.
    RX12_CS_B      : out std_logic;                        --! I2C chip select signal to RX12 firefly, tied to '1'. Connected to bank 66.
    RX12_RST_B     : out std_logic;                        --! Reset signal to RX12 firefly, tied to '1'. Connected to bank 66.
    RX12_INT_B     : in std_logic;                         --! Interrupt (fault) signal from RX12 firefly, currently unused. Connected to bank 66.
    RX12_PRESENT_B : in std_logic;                         --! Present signal from RX12 firefly, currently unused. Connected to bank 66.

    TX12_I2C_ENA   : out std_logic;                        --! I2C enable for TX12 firefly, currently tied to 0. Connected to bank 66.
    TX12_SDA       : inout std_logic;                      --! I2C serial data signal to/from TX12 firefly, currently unused. Connected to 66.
    TX12_SCL       : inout std_logic;                      --! I2C serial clock signal to TX12 firefly, currently unused. Connected to bank 66.
    TX12_CS_B      : out std_logic;                        --! I2C chip select signal to TX12 firefly, tied to '1'. Connected to bank 66.
    TX12_RST_B     : out std_logic;                        --! Reset signal to TX12 firefly, tied to '1'. Connected to bank 66.
    TX12_INT_B     : in std_logic;                         --! Interrupt (fault) signal from TX12 firefly, currently unused. Connected to bank 66.
    TX12_PRESENT_B : in std_logic;                         --! Present signal from TX12 firefly, currently unused. Connected to bank 66.

    B04_I2C_ENA   : out std_logic;                         --! I2C enable for B04 firefly, currently tied to 0. Connected to bank 66.
    B04_SDA       : inout std_logic;                       --! I2C serial data signal to/from B04 firefly, currently unused. Connected to bank 66.
    B04_SCL       : inout std_logic;                       --! I2C serial clock signal to B04 firefly, currently unused. Connected to bank 66.
    B04_CS_B      : out std_logic;                         --! I2C chip select signal to B04 firefly, tied to '1'. Connected to bank 66.
    B04_RST_B     : out std_logic;                         --! Reset signal to B04 firefly, tied to '1'. Connected to bank 66.
    B04_INT_B     : in std_logic;                          --! Interrupt (fault) signal from B04 firefly, currently unused. Connected to bank 66.
    B04_PRESENT_B : in std_logic;                          --! Present signal from B04 firefly, currently unused. Connected to bank 66.

    SPY_I2C_ENA   : out std_logic;                         --! I2C enable for Finisar, currently unused. Connected to bank 66.
    SPY_SDA       : inout std_logic;                       --! I2C serial data to/from Finisar, currently unused. Connected to bank 66.
    SPY_SCL       : inout std_logic;                       --! I2C serial clock to Finisar, currently unused. Connected to bank 66.
    SPY_SD        : in std_logic;                          --! Finisar signal detect signal, currently unused. Connected to bank 66.
    SPY_TDIS      : out std_logic;                         --! Transmitter disable signal to Finisar, tied to '0'. Connected to bank 66.

    --------------------------------
    -- Essential selector/reset signals not classified yet
    --------------------------------
    ODMB_DONE     : in std_logic;                          --! Kintex Ultrascale configuration DONE signal from DONE_0 in bank 0 (N7). Unused but needs to be input. Connected to bank 66 (pin L9).

    --------------------------------
    -- System monitoring ports
    --------------------------------
    SYSMON_P      : in std_logic_vector(15 downto 0);      --! Current monitoring analog signals from monitor ICs to SYSTEM_MON in VME module. Connected to bank 64.
    SYSMON_N      : in std_logic_vector(15 downto 0);      --! Current monitoring analog signals from monitor ICs to SYSTEM_MON in VME module. Connected to bank 64.
    ADC_CS_B      : out std_logic_vector(4 downto 0);      --! SPI chip select signals to voltage monitor ADCs used by SYSTEM_MON in VME module. Connected to bank 64.
    ADC_DIN       : out std_logic;                         --! SPI input signal to voltage monitor ADCs used by SYSTEM_MON in VME module. Connected to bank 64.
    ADC_SCK       : out std_logic;                         --! SPI clock signal to voltage monitor ADCs used by SYSTEM_MON in VME module. Connected to bank 64.
    ADC_DOUT      : in std_logic;                          --! SPI output signal from voltage monitor ADCs used by SYSTEM_MON in VME module. Connected to bank 64.

    --------------------------------
    -- PROM pins
    --------------------------------
    PROM_RST_B    : out std_logic;                         --! Reset signal to both PROM ICs currently tied to 1. Connected to bank 65.
    PROM_CS2_B    : out std_logic;                         --! Chip select signal to secondary PROM, used by spi_interface in ODMB_VME. Connected to bank 65.
    CNFG_DATA     : inout std_logic_vector(7 downto 4);    --! Data signals to/from the secondary PROM, used by spi_interface in ODMB_VME. Connected to bank 65.

    --------------------------------
    -- Clock synthesizer control signals
    --------------------------------
    RST_CLKS_B    : out std_logic;                         --! Clock synthesizer reset signal, needs to be tied to '1'. Connected to bank 47.
    FPGA_SEL      : out std_logic;                         --! Clock synthesizer control input selector. Currently tied to '0'. '0' is control by usb, '1' is control by fpga. Connected to bank 47.
    FPGA_AC       : out std_logic_vector(2 downto 0);      --! Clock synthesizer auto-configuration number used at reset. Connected to bank 47.
    FPGA_TEST     : out std_logic;                         --! Clock synthesizer test mode. Nominally 0. Connected to bank 47.
    FPGA_IF0_CSN  : out std_logic;                         --! Clock synthesizer interface mode to select i2c(00-10) or spi(11) during reset. After reset, spi chip select. Connected to bank 47.
    FPGA_IF1_MISO : inout std_logic;                       --! Clock synthesizer interface mode to select i2c(00-10) or spi(11) during reset. After reset, spi miso. Connected to bank 47.
    FPGA_SCLK     : out std_logic;                         --! Clock synthesizer clock. Connected to bank 47.
    FPGA_MOSI     : inout std_logic;                       --! Clock synthesizer spi mosi or i2c sda. Connected to bank 47.

    --------------------------------
    -- Test point pins
    --------------------------------
    THTP          : out std_logic_vector(15 downto 0);     --! Through hole test point pins. Connected to bank 47.
    SMTP          : out std_logic_vector(15 downto 0);     --! Surface mount test point pins. Connected to bank 48.

    --------------------------------
    -- Others
    --------------------------------
    LEDS_HEART_BEAT : out std_logic;                       --! On-board LED. Connected to bank 65.
    LEDS_SPARE      : out std_logic;                       --! On-board LED. Connected to bank 65.
    LEDS_CFV        : out std_logic_vector(11 downto 0)    --! Front panel LEDs, currently unused. Connected to bank 65.
    );
end odmb7_ucsb_dev;

architecture Behavioral of odmb7_ucsb_dev is

  --------------------------------------
  -- Clock signals
  --------------------------------------
  signal mgtrefclk0_224 : std_logic;
  signal mgtrefclk0_225 : std_logic;
  signal mgtrefclk0_226 : std_logic;
  signal mgtrefclk1_226 : std_logic;
  signal mgtrefclk0_227 : std_logic;
  signal mgtrefclk1_227 : std_logic;
  signal sysclk625k : std_logic;
  signal sysclk1p25 : std_logic;
  signal sysclk2p5 : std_logic;
  signal sysclk10 : std_logic;
  signal sysclk20 : std_logic;
  signal sysclk40 : std_logic;
  signal sysclk80 : std_logic;
  signal cmsclk : std_logic;
  signal clk_lfclk : std_logic;
  signal clk_gp6 : std_logic;
  signal clk_gp7 : std_logic;
  signal mgtclk1 : std_logic;
  signal mgtclk2 : std_logic;
  signal mgtclk3 : std_logic;
  signal mgtclk4 : std_logic;
  signal mgtclk5 : std_logic;
  signal mgtclk125 : std_logic;
  signal led_clkfreqs : std_logic_vector(7 downto 0);

  --------------------------------------
  -- Signals for DCFEB I/O buffers to prevent implementation errors
  --------------------------------------
  signal dcfeb_tck    : std_logic_vector (7 downto 1) := (others => '0');
  signal dcfeb_l1a_match    : std_logic_vector(7 downto 1) := (others => '0');
  signal dcfeb_tms    : std_logic := '0';
  signal dcfeb_tdi    : std_logic := '0';
  signal dcfeb_injpls       : std_logic := '0';
  signal dcfeb_extpls       : std_logic := '0';
  signal dcfeb_resync       : std_logic := '0';
  signal dcfeb_bc0          : std_logic := '0';
  signal dcfeb_l1a          : std_logic := '0';

begin

  -------------------------------------------------------------------------------------------
  -- Handle clock synthesizer signals and generate clocks
  -------------------------------------------------------------------------------------------
  MBK : entity work.odmb_clocking
    port map (
      CMS_CLK_FPGA_P => CMS_CLK_FPGA_P,
      CMS_CLK_FPGA_N => CMS_CLK_FPGA_N,
      GP_CLK_6_P     => GP_CLK_6_P,
      GP_CLK_6_N     => GP_CLK_6_N,
      GP_CLK_7_P     => GP_CLK_7_P,
      GP_CLK_7_N     => GP_CLK_7_N,
      REF_CLK_1_P    => REF_CLK_1_P,
      REF_CLK_1_N    => REF_CLK_1_N,
      REF_CLK_2_P    => REF_CLK_2_P,
      REF_CLK_2_N    => REF_CLK_2_N,
      REF_CLK_3_P    => REF_CLK_3_P,
      REF_CLK_3_N    => REF_CLK_3_N,
      REF_CLK_4_P    => REF_CLK_4_P,
      REF_CLK_4_N    => REF_CLK_4_N,
      REF_CLK_5_P    => REF_CLK_5_P,
      REF_CLK_5_N    => REF_CLK_5_N,
      CLK_125_REF_P  => CLK_125_REF_P,
      CLK_125_REF_N  => CLK_125_REF_N,
      LF_CLK         => LF_CLK,
      -- Output clocks
      mgtrefclk0_224 => mgtrefclk0_224,
      mgtrefclk0_225 => mgtrefclk0_225,
      mgtrefclk0_226 => mgtrefclk0_226,
      mgtrefclk1_226 => mgtrefclk1_226,
      mgtrefclk0_227 => mgtrefclk0_227,
      mgtrefclk1_227 => mgtrefclk1_227,
      clk_sysclk625k => sysclk625k,
      clk_sysclk1p25 => sysclk1p25,
      clk_sysclk2p5  => sysclk2p5,
      clk_sysclk10   => sysclk10,
      clk_sysclk20   => sysclk20,
      clk_sysclk40   => sysclk40,
      clk_sysclk80   => sysclk80,
      clk_cmsclk     => cmsclk,
      clk_lfclk      => clk_lfclk,
      clk_gp6        => clk_gp6,
      clk_gp7        => clk_gp7,
      clk_mgtclk1    => mgtclk1,
      clk_mgtclk2    => mgtclk2,
      clk_mgtclk3    => mgtclk3,
      clk_mgtclk4    => mgtclk4,
      clk_mgtclk5    => mgtclk5,
      clk_mgtclk125  => mgtclk125,
      led_clkfreqs   => led_clkfreqs
      );

  -------------------------------------------------------------------------------------------
  -- Make LED lights blink to reflect clock frequencies
  -------------------------------------------------------------------------------------------
  LEDS_CFV(0)  <= led_clkfreqs(0);  -- cmsclk   :  40 MHz = led at 134/40  ~ 3.4 Hz
  LEDS_CFV(2)  <= led_clkfreqs(1);  -- mgtclk1  : 160 MHz = led at 134/160 ~ 0.8 Hz
  LEDS_CFV(4)  <= led_clkfreqs(3);  -- mgtclk3  : 160 MHz = led at 134/160 ~ 0.8 Hz
  LEDS_CFV(6)  <= led_clkfreqs(4);  -- mgtclk4  : 120 MHz = led at 134/120 ~ 1.1 Hz
  LEDS_CFV(8)  <= led_clkfreqs(6);  -- mgtclk125: 125 MHz = led at 134/125 ~ 1.1 Hz
  LEDS_CFV(10) <= led_clkfreqs(7);  -- clk_gp7  : 80 MHz  = led at 134/80  ~ 1.7 Hz

  -------------------------------------------------------------------------------------------
  -- Constant driver for CONFIGURE, CLOCK pins
  -------------------------------------------------------------------------------------------
  --KUS_DL_SEL <= '1'; -- Discrete logic controls JTAG. But not used anymore.
  --FPGA_SEL <= '0'; -- Selects FPGA controls clock synthesizer. Pulled to '0'.
  --RST_CLKS_B <= '1'; -- Reset clock synthesizer. Pulled to '1'.

  -------------------------------------------------------------------------------------------
  -- Constant driver for firefly selector/reset pins
  -------------------------------------------------------------------------------------------
  RX12_I2C_ENA <= '0'; -- Pulled to '0'
  RX12_RST_B <= '1';
  TX12_RST_B <= '1';
  B04_RST_B <= '1';
  SPY_TDIS <= '0';
  --RX12_CS_B <= '1';
  --TX12_I2C_ENA <= '0';
  --TX12_CS_B <= '1';
  --B04_I2C_ENA <= '0';
  --B04_CS_B <= '1';

  -------------------------------------------------------------------------------------------
  -- DCFEB I/O buffers to prevent implementation errors
  -------------------------------------------------------------------------------------------
  OB_DCFEB_TMS: OBUFDS port map (I => dcfeb_tms, O => DCFEB_TMS_P, OB => DCFEB_TMS_N);
  OB_DCFEB_TDI: OBUFDS port map (I => dcfeb_tdi, O => DCFEB_TDI_P, OB => DCFEB_TDI_N);
  OB_DCFEB_INJPLS: OBUFDS port map (I => dcfeb_injpls, O => INJPLS_P, OB => INJPLS_N);
  OB_DCFEB_EXTPLS: OBUFDS port map (I => dcfeb_extpls, O => EXTPLS_P, OB => EXTPLS_N);
  OB_DCFEB_RESYNC: OBUFDS port map (I => dcfeb_resync, O => RESYNC_P, OB => RESYNC_N);
  OB_DCFEB_BC0: OBUFDS port map (I => dcfeb_bc0, O => BC0_P, OB => BC0_N);
  OB_DCFEB_L1A: OBUFDS port map (I => dcfeb_l1a, O => L1A_P, OB => L1A_N);
  GEN_DCFEBJTAG_7 : for I in 1 to 7 generate
  begin
    OB_DCFEB_TCK: OBUFDS port map (I => dcfeb_tck(I), O => DCFEB_TCK_P(I), OB => DCFEB_TCK_N(I));
    OB_DCFEB_L1A_MATCH: OBUFDS port map (I => dcfeb_l1a_match(I), O => L1A_MATCH_P(I), OB => L1A_MATCH_N(I));
  end generate GEN_DCFEBJTAG_7;

end Behavioral;
