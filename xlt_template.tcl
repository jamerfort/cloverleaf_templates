# This xlate proc ...
#
# Usage:
# ------------------------------------------------------------------------------
#  Source                                                  Destination
#  ---------------------                                   ---------------------
# | ARG                |  -------                         | OUTPUT             |
# |                    | |PreProc|                        |                    |
# |                    |  ------------------------------  |                    |
# |                    | | xlt_template                 | |                    |
# |                    | |                              | |                    |
#  --------------------- --------------------------------  ---------------------
#
# Example:
# ------------------------------------------------------------------------------
#  Source                                                  Destination
#  ---------------------                                   ---------------------
# | 000123456          |  -------                         | @pid4              |
# |                    | |PreProc|                        |                    |
# |                    |  ------------------------------  |                    |
# |                    | | xlt_template                 | |                    |
# |                    | |                              | |                    |
#  --------------------- --------------------------------  ---------------------
#
# History:
# 	- <NAME> - <DATE>
# 		<CHANGE ENTRY>
proc xlt_template {} {
	upvar	xlateInVals xlateInVals \
			xlateOutVals xlateOutVals

	# get the input
	set arg [lindex $xlateInVals 0]

	# process
	set output [somefunction]

	# set the output
	set xlateOutVals [list $output]
}
