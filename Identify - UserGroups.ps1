Set-ExecutionPolicy -ExecutionPolicy bypass -Scope Process -Force

connect-azuread

$userList = Get-AzureADUser -filter "accountenabled eq true" | select -expandproperty mail

$table = New-Object System.Data.Datatable
[void]$table.Columns.Add("User")
[void]$table.Columns.Add("Groups")

foreach ($user in $userList){

    $rando = Get-Random -Minimum 502 -Maximum 660
    start-sleep -Milliseconds $rando

    $groups = Get-AzureADUser -SearchString $user | Get-AzureADUserMembership | ? {$_.ObjectType -ne "Role"}  | % {Get-AzureADGroup -ObjectId $_.ObjectId | select -expandproperty DisplayName} | convertto-json | convertfrom-json | out-string
    [void]$table.Rows.Add($user, $groups)
}

$table | Export-Csv -LiteralPath $env:TMP\export.csv
$table | fl
cd $env:TMP
.\export.csv
