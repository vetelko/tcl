source tester.tcl

proc create_list {args} {
	# args is built-in variable and it is list
	return $args
}

test failure_1.0 {
	set str "string"
	string length $str
} {1}

test create_list_1.0 { 
	create_list 2 2
} {2 2}

test create_list_1.1 {
	create_list 1 2 3 4
} {1 2 3 4} 

test sqlite_create_table_1.0 {
	db_test { create table t1 (a, b) }
} {0 {}}

test sqlite_create_table_1.1 {
	db_test { create table t1 (a, b) }
} {1 {table t1 already exists}}

