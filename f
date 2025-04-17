$ExcludeDirs = @("bin", "obj", ".git", ".vs", "node_modules", "packages")
$IncludeExtensions = @("*.cs", "*.csproj", "*.sln", "*.ts", "*.html", "*.json")

$Root = "C:\Path\To\Your\App"
$FromLower = 'a'
$FromPascal = 'b' # don't worry about case here
$ToLower = 'A'
$ToPascal = 'B'

# Replace file content
Get-ChildItem -Path $Root -Recurse -File -Include $IncludeExtensions -Force |
    Where-Object { $ExcludeDirs -notcontains $_.Directory.Name } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $content = [regex]::Replace($content, $FromLower, $ToLower, 'IgnoreCase')
        $content = [regex]::Replace($content, $FromPascal, $ToPascal, 'IgnoreCase')
        Set-Content $_.FullName $content
    }

# Rename files and directories (bottom-up to avoid path errors)
Get-ChildItem -Path $Root -Recurse -File, -Directory -Force |
    Sort-Object FullName -Descending |
    Where-Object { $ExcludeDirs -notcontains $_.Name } |
    ForEach-Object {
        $newName = $_.Name
        $newName = [regex]::Replace($newName, $FromLower, $ToLower, 'IgnoreCase')
        $newName = [regex]::Replace($newName, $FromPascal, $ToPascal, 'IgnoreCase')

        if ($newName -ne $_.Name) {
            Rename-Item -LiteralPath $_.FullName -NewName $newName
        }
    }
