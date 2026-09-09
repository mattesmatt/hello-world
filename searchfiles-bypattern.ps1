$Pattern = 'patterntomatch'
 $OutFile = 'C:\Temp\pattern_Matches.txt'

# Clear previous output file
 if (Test-Path $OutFile) {
 Remove-Item $OutFile
 }

$Files = Get-ChildItem 'C:\Directory\Subfolder' -Directory |
 ForEach-Object {
 Get-ChildItem "$($_.FullName)\CM\Swift\Archive" -File -Recurse -ErrorAction SilentlyContinue
 }

$Total = $Files.Count
 $Current = 0

foreach ($File in $Files) {

 $Current++

 Write-Progress `
 -Activity "Searching SWIFT Archives" `
 -Status "$Current of $Total files" `
 -PercentComplete (($Current / $Total) * 100)

 $Matches = Select-String -Path $File.FullName `
 -Pattern $Pattern `
 -SimpleMatch

 foreach ($Match in $Matches) {
 $Result = "$($Match.Path):$($Match.LineNumber): $($Match.Line)"

 # Display on screen
 Write-Host $Result

 # Save to file
 Add-Content -Path $OutFile -Value $Result
 }
 }

Write-Progress -Activity "Searching SWIFT Archives" -Completed

Write-Host ""
 Write-Host "Search complete."
 Write-Host "Results saved to $OutFile"