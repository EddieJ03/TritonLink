$connectionString = "postgresql://postgres:edward@localhost:5432/cse132b"
$scriptFile = "drop_tables.sql"

psql -d $connectionString -f $scriptFile
