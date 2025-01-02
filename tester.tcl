# ----------------------------------------------------------------
# My simple test suite :D It's enough in most use cases.
# ----------------------------------------------------------------

# Main testing procedure
# Usage:
# test name {
#		body
# } {wanted}
proc test {name body wanted} {
	if {$wanted eq {}} {
		set wanted -nothing-
	}	
	set got [eval $body]
	set error_line [lindex [info frame -1] 3]
	if { $got eq $wanted } {
		puts "PASS: $name"
	} else {
		puts "FAIL: $name, want: $wanted, got: $got line: $error_line"
	}
}

# For testing SQLite database itself. Execute SQL and catch exceptions. 
# This is rewrite of catchsql proc from original SQLite test suite 
# https://sqlite.org/src/file?name=test/tester.tcl&ci=trunk
proc db_test {sql} {
	sqlite3 db tester.sq3
	set r [catch [list uplevel [list db eval $sql]] msg]
	lappend r $msg
	return $r
}

# Executes SQL if you need to use SQLite in test functions
proc db_eval {sql {show_sql 0}} {
	if {$show_sql == 1} {
		puts $sql
	}
	sqlite3 db tester.sq3
	db eval $sql
}

# Prepares environment to use SQLite database
# not only for testing SQLite itself but for using it
# store temporary data related to test
proc db_init {} {
	# ...
	if {[file exists tester.sq3]} {
		file delete tester.sq3
	}
}

# ----------------------------------------------------------------
db_init
# ----------------------------------------------------------------

