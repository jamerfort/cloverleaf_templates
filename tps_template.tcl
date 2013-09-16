# Description
#
# History:
# 	- <NAME> - <DATE>
# 		<CHANGE ENTRY>
proc tps_proc_name {args} {
	# set the procedure name
	# This is used for error messages
	set procname [lindex [info level [info level]] 0]
	
	# bring some common variables into the scope of this proc
	global HciSite HciSiteDir HciProcessesDir HciConnName HciRootDir ibdir
		
	# fetch mode
	keylget args MODE mode
	# keylget args ARGS.ARGNAME argname
	
	switch -exact -- $mode {
		start {
			# Perform special init functions
			# N.B.: there may or may not be a MSGID key in args
		}
		
		run {
			# 'run' mode always has a MSGID; fetch and process it
			keylget args MSGID msgid
			
			# get the message
			set msgdata [msgget $msgid]

			# get the separators
			set segment_sep \r
			set field_sep [string index $msgdata 3]; # |
			set comp_sep [string index $msgdata 4]; # ^
			set rep_sep [string index $msgdata 5]; # ~
			set escape_sep [string index $msgdata 6]; # \ 
			set subcomp_sep [string index $msgdata 7]; # &
			
			# process the message
			if { [catch {
				# commands

				# split the message into segments
				set segments [split $msgdata $segment_sep]

				# loop through each segment
				set seg_index -1
				foreach segment $segments {
					incr seg_index

					set fields [split $segment $field_sep]
					set seg_type [lindex $fields 0]

					# do something
					switch -exact -- $seg_type {
						MSH {}
						PID {}
						PV1 {}
					}

					# rebuild the segment
					set segment [join $fields $field_sep]

					set segments [lreplace $segments $seg_index $seg_index $segment]
				}

				# rebuild the message
				set msgdata [join $segments $segment_sep]
				
				
			} errmsg ] } {
				# the commands errored
				
				global errorInfo
				
				msgmetaset $msgid USERDATA "ERROR: $errmsg\n*** Tcl TRACE ***\n$errorInfo"
				
				# rethrow the error
				error $errmsg $errorInfo
			}
			
			# set the output message
			msgset $msgid $msgdata
			
			# return whether to kill, continue, etc. the message
			# return "{KILLREPLY $msgid}"
			# return "{KILL $msgid}"
			# return "{ERROR $msgid}"
			return "{CONTINUE $msgid}"
			
		}
		
		time {
			# Timer-based processing
			# N.B.: there may or may not be a MSGID key in args
		}
		
		shutdown {
			# Do some clean-up work
		}
		
		default {
			error "Unknown mode in $procname: $mode"
			return ""	;# Dont know what to do
		}
	}
	
}
