# --- CONFIGURABLE SECTION ---
$Root = "C:\Path\To\Your\App"
$FromLower = 'a'
$FromPascal = 'b' # don't worry about case here
$ToLower = 'A'
$ToPascal = 'B'

$ExcludeDirs = @("bin", "obj", ".git", ".vs", "node_modules", "packages")
$IncludeExtensions = @("*.cs", "*.csproj", "*.sln", "*.ts", "*.html", "*.json")
# ----------------------------

Write-Host "`n📁 Starting content replacement..." -ForegroundColor Cyan

# Replace content inside files
Get-ChildItem -Path $Root -Recurse -File -Include $IncludeExtensions -Force |
    Where-Object {
        $dir = $_.Directory
        $dir -ne $null -and ($ExcludeDirs -notcontains $dir.Name)
    } |
    ForEach-Object {
        $filePath = $_.FullName
        Write-Host "🔄 Updating content in: $filePath" -ForegroundColor DarkGray

        $content = Get-Content $filePath -Raw
        $content = [regex]::Replace($content, $FromLower, $ToLower, 'IgnoreCase')
        $content = [regex]::Replace($content, $FromPascal, $ToPascal, 'IgnoreCase')
        Set-Content $filePath $content
    }

Write-Host "`n📂 Starting file/folder renaming..." -ForegroundColor Cyan

# Combine all files and directories, sort deepest-first
$items = @(Get-ChildItem -Path $Root -Recurse -File -Force) + 
         @(Get-ChildItem -Path $Root -Recurse -Directory -Force)

$items |
    Sort-Object FullName -Descending |
    Where-Object {
        $ExcludeDirs -notcontains $_.Name
    } |
    ForEach-Object {
        $newName = $_.Name
        $newName = [regex]::Replace($newName, $FromLower, $ToLower, 'IgnoreCase')
        $newName = [regex]::Replace($newName, $FromPascal, $ToPascal, 'IgnoreCase')

        if ($newName -ne $_.Name) {
            Write-Host "✏️  Renaming: $($_.FullName) -> $newName" -ForegroundColor Yellow
            Rename-Item -LiteralPath $_.FullName -NewName $newName
        }
    }

Write-Host "`n✅ Done! All matching names and contents have been updated." -ForegroundColor Green
