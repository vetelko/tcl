# ----------------------------------------------------------------
# My simple test suite :D It's enough in most use cases.
# ----------------------------------------------------------------

# Main testing procedure
# Usage:
# test name {
#		body
# } {wanted}
proc test {name body wanted {dblog 0}} {
	set fail_line 0
	if {$wanted eq {}} {
		set wanted -nothing-
	}	
	set got [eval $body]
	if { $got eq $wanted } {
		puts "PASS: $name"
	} else {
		set fail_line [lindex [info frame -1] 3]
		puts "FAIL: $name, want: $wanted, got: $got line: $fail_line"
	}
	if {$dblog} {
		db_eval {create table if not exists fails(name, want, got, line)}
		db_eval {insert into fails values ($name, $wanted, $got, $fail_line)} 1
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
	set r [catch [list uplevel [list db eval $sql]] msg]
	lappend r $msg
	return $r
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

