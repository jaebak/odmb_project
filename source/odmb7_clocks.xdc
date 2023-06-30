# ODMB7 Input Clock Constraints XDC file
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------
# Create system clock groups
# ----------------------------------
create_clock -name cms_clk  -period 25    [get_ports CMS_CLK_FPGA_P]
create_clock -name gp_clk_6 -period 12.5  [get_ports GP_CLK_6_P]
create_clock -name gp_clk_7 -period 12.5  [get_ports GP_CLK_7_P]
create_clock -name lf_clk -period 100000  [get_ports LF_CLK]
set_clock_groups -group [get_clocks cms_clk -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gp_clk_6 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gp_clk_7 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks lf_clk -include_generated_clocks] -asynchronous
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {LF_CLK_IBUF_inst/O}]

# ----------------------------------
# Create the MGT reference clocks
# ----------------------------------
create_clock -name gth_refclk0_q224 -period 6.25 [get_ports REF_CLK_1_P]
create_clock -name gth_refclk0_q225 -period 8.33 [get_ports REF_CLK_4_P]
create_clock -name gth_refclk0_q226 -period 6.25 [get_ports REF_CLK_3_P]
create_clock -name gth_refclk1_q226 -period 8    [get_ports CLK_125_REF_P]
create_clock -name gth_refclk0_q227 -period 6.25 [get_ports REF_CLK_2_P]
create_clock -name gth_refclk1_q227 -period 8.33 [get_ports REF_CLK_5_P]
set_clock_groups -group [get_clocks gth_refclk0_q224 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk0_q225 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk0_q226 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk1_q226 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk0_q227 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk1_q227 -include_generated_clocks] -asynchronous

