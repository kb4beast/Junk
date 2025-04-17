$ExcludeDirs = @("bin", "obj", ".git", ".vs", "node_modules", "packages")
$IncludeExtensions = @("*.cs", "*.csproj", "*.sln", "*.ts", "*.html", "*.json")

$Root = "C:\Path\To\Your\App"
$FromLower = 'from-lower'
$FromPascal = 'FromLower'
$ToLower = 'to-search'
$ToPascal = 'ToSearch'

# Rename file content
Get-ChildItem -Path $Root -Recurse -File -Include $IncludeExtensions |
    Where-Object { $ExcludeDirs -notcontains $_.Directory.Name } |
    ForEach-Object {
        (Get-Content $_.FullName) `
        -replace $FromLower, $ToLower `
        -replace $FromPascal, $ToPascal |
        Set-Content $_.FullName
    }

# Rename files and directories (bottom-up to avoid path errors)
Get-ChildItem -Path $Root -Recurse -Directory, -File |
    Sort-Object FullName -Descending |
    Where-Object {
        $ExcludeDirs -notcontains $_.Name
    } |
    ForEach-Object {
        $newName = $_.Name `
            -replace $FromLower, $ToLower `
            -replace $FromPascal, $ToPascal

        if ($newName -ne $_.Name) {
            Rename-Item $_.FullName -NewName $newName
        }
    }
