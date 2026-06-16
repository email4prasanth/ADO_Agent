# Define output file
$outputFile = "zzetacombined.tf"

# Remove existing output file
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
    Write-Output "$outputFile already existed and was deleted."
}

# Combine root-level .tf files
Get-ChildItem -Path . -Filter "*.tf" |
Where-Object { $_.Name -ne $outputFile } |
ForEach-Object {

    Add-Content -Path $outputFile -Value "### File: $($_.Name) ###"

    Get-Content $_.FullName | Add-Content $outputFile

    Add-Content $outputFile -Value "`n"
}

# Combine module .tf files only if modules folder exists
if (Test-Path ".\modules") {

    Get-ChildItem -Path ".\modules" -Directory | ForEach-Object {

        $moduleName = $_.Name

        Get-ChildItem -Path $_.FullName -Filter "*.tf" | ForEach-Object {

            Add-Content -Path $outputFile -Value "### File: modules\$moduleName\$($_.Name) ###"

            Get-Content $_.FullName | Add-Content $outputFile

            Add-Content $outputFile -Value "`n"
        }
    }
}

Write-Output "Combined files into $outputFile"