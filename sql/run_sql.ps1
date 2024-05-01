# Check if there are files matching the pattern
$files = Get-ChildItem -Path .\ -Filter create_*.sql

# Run psql command if matching files exist
if ($files.Count -gt 0) {
    foreach ($file in $files) {
        psql -d "postgresql://postgres:edward@localhost:5432/cse132b" -f $file.FullName
    }
} else {
    Write-Host "No files found matching the pattern create_*.SQL"
}
