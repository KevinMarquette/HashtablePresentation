# Group-Object as hashtable
Get-ChildItem

$files = Get-ChildItem | 
    Group-Object -AsHashTable -Property Name
$files

$files['Part1.ps1']
$files['Part1.ps1'].fullname

# -AsString
$files = Get-ChildItem | 
    Group-Object -AsHashTable -Property Basename -AsString

$files['Part1'].fullname


# special hashtables
# PSBoundParameters
function test-param 
{
    [cmdletbinding()]
    param(
        $First = 1
    )
    if ($null -ne $First)
    {
        "First has a value of [$First]"
    }
    if ($PSBoundParameters.ContainsKey('First'))
    {
        "The passed in value for First is [{0}]" -f $PSBoundParameters.First
    }
    else
    {
        "No value was provided for first, using the default [$First]"
    }
}

Test-Param -First 90210
Test-Param
Test-Param -First $null


# Proxy functions with PSBoundParameters
function Get-ProxyCimInstance
{
    [cmdletbinding()]
    param(
        $Class,
        $ComputerName
    )
    Get-CimInstance @PSBoundParameters
}

Get-ProxyCimInstance -Class Win32_BIOS


# PSDefaultParameterValues
$PSDefaultParameterValues[ "Format-Table:AutoSize" ] = $true
$PSDefaultParameterValues[ "Out-File:Encoding" ]     = "UTF8"
$PSDefaultParameterValues[ "Connect-VIServer:Server" ] = 'VCENTER01.contoso.local'

$PSDefaultParameterValues[ "Install-Module:Scope" ] = 'CurrentUser'
$PSDefaultParameterValues[ "Install-Module:Force" ] = $true
$PSDefaultParameterValues[ "Install-Module:AllowClobber" ] = $true
$PSDefaultParameterValues[ "Install-Module:SkipPublisherCheck" ] = $true
$PSDefaultParameterValues[ "Install-Module:AcceptLicense" ] = $true
$PSDefaultParameterValues[ "Install-Module:Repository" ] = 'PSGallery'

# With wildcards
$PSDefaultParameterValues[ "Get-*:Verbose" ] = $true
$PSDefaultParameterValues[ "*:Credential" ]  = Get-Credental
$PSDefaultParameterValues[ "*-AD*:Server" ]  = 'Lab.domain'


# regex matches

$message = 'My SSN is 123-45-6789.'

$message -match 'My SSN is (.+)\.'
$Matches[0]
$Matches[1]

# Named matches
$message = 'My SSN is 123-45-6789.'

$message -match 'My SSN is (?<SSN>.+)\.'
$Matches.SSN

$message = 'My Name is Kevin and my SSN is 123-45-6789.'

$message -match 'My Name is (?<Name>.+) and my SSN is (?<SSN>.+)\.'
$Matches.Name
$Matches.SSN


# Hashmap
$data = 1..8 | Get-Random -Count 4

$hashtable = @{}
$data | ForEach-Object {
    $hashtable[$PSItem] = $true
}
foreach($number in 1..8)
{
    if($hashtable.Contains($number))
    {
        "$number is a winner"
    }
    else
    {
        "$number is a loser"
    }
}

$set = [System.Collections.Generic.HashSet[int]]::new()
$data | ForEach-Object {
    [void]$set.Add($PSItem)
}
foreach($number in 1..8)
{
    if($set.Contains($number))
    {
        "$number is a winner"
    }
    else
    {
        "$number is a loser"
    }
}
