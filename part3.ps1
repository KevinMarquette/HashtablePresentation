# Performance

# test data
$servers = foreach($index in 1..1000)
{
    [pscustomobject]@{
        Name = "Server$index"
        SiteID = ($index % 6 * 2)
    }
}


# walking a collection of data
# using JSON but could be a CSV import
$json = @'
[
    {"Name":"ATX","ID":"0"},
    {"Name":"LAX","ID":"2"}, 
    {"Name":"DEN","ID":"4"}, 
    {"Name":"OMA","ID":"6"}, 
    {"Name":"CHI","ID":"8"}, 
    {"Name":"REN","ID":"10"} 
]
'@

$lookupArray = $json | convertfrom-json
$lookupArray

Measure-Command {
    foreach($server in $servers){
        @{
            Name = $server.name
            Location = ($lookupArray | where ID -eq $server.siteID).Name
        }  
    }
}

Measure-Command {
    foreach($server in $servers){
        foreach($location in $lookupArray){
            if($server.SiteID -eq $location.ID){
                @{
                    Name = $server.name
                    Location = $location.name
                }
            }
        }
    }
}



# hashtable lookups
$lookupHash = @{
    0 = 'ATX'
    2 = 'LAX'
    4 = 'DEN'
    5 = 'OMA'
    6 = 'CHI'
    8 = 'REN'
}
$lookupHash

Measure-Command {
    foreach($server in $servers){    
        @{
            Name = $server.name
            Location = $lookupHash[$server.SiteID]
        }          
    }
}




# Pass by refference and Shallow copies
# value types
$orig = 1
$copy = $orig
$copy = 2
'Copy: [{0}]' -f $copy
'Orig: [{0}]' -f $orig


# Reference types
$orig = @{name='orig'}
$copy = $orig
$copy.name = 'copy'
'Copy: [{0}]' -f $copy.name
'Orig: [{0}]' -f $orig.name



# Shallow copies, single level
$orig = @{name='orig'}
$copy = $orig.Clone()
$copy.name = 'copy'
'Copy: [{0}]' -f $copy.name
'Orig: [{0}]' -f $orig.name



# Shallow copies, nested
$orig = @{
    person=@{
        name='orig'
    }
}
$copy = $orig.Clone()
$copy.person.name = 'copy'
'Copy: [{0}]' -f $copy.person.name
'Orig: [{0}]' -f $orig.person.name



# special hashtables
# PSBoundParameters
function test-param 
{
    [cmdletbinding()]
    param(
        $First = 1
    )
    If($First -ne $null){
        "First has a value of $first"
    }
    If($PSBoundParameters['First'] -ne $null)
    {
        "The passed in value of First is $First"
    }
    else
    {
        "No value was provided for first, using the default $First"
    }
}

Test-Param -First 90210
Test-Param


# Proxy functions with PSBoundParameters
function Get-ProxyWMIObject 
{
    [cmdletbinding()]
    param(
        $Class,
        $ComputerName
    )
    Get-WmiObject @PSBoundParameters
    
}

Get-ProxyWMIObject  -Class WIN32_BIOS


# PSDefaultParameterValues
$PSDefaultParameterValues[ "Connect-VIServer:Server" ] = 'VCENTER01.contoso.local'

$PSDefaultParameterValues["Out-File:Encoding"] = "UTF8"

$PSDefaultParameterValues[ "Get-*:Verbose" ] = $true
$PSDefaultParameterValues[ "*:Credential" ] = Get-Credental


# regex matches

$message = 'My SSN is 123-45-6789.'

if($message -match 'My SSN is (.+)\.'){
    $Matches[0]
    $Matches[1]
}

# Named matches
$message = 'My SSN is 123-45-6789.'

$message -match 'My SSN is (?<SSN>.+)\.'
$Matches.SSN

$message = 'My Name is Kevin and my SSN is 123-45-6789.'

$message -match 'My Name is (?<Name>.+) and my SSN is (?<SSN>.+)\.'
$Matches.Name
$Matches.SSN

