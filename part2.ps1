# The fun stuff
# Ordered hashtables
$person = @{
    name = 'Kevin'
    age  = 37
}


# Inline
$person = @{ name = 'kevin'; age = 37; }


# Custom expressions in common pipeline commands
$drives = Get-PSDrive | Where Used 
$drives | Get-Member
$drives | Select-Object Name,@{n='totalSpaceGB';e={ ($_.used + $_.free) / 1GB }}


# Expanded
$property = @{
    name = 'totalSpaceGB'
    expression = { ($_.used + $_.free) / 1GB }
}

$drives | Select-Object Name,$property

$drives | ForEach-Object {  
    [pscustomobject]@{
        Name = $_.name
        totalSpaceGB =  ($_.used + $_.free) / 1GB       
    }
}

# Splatting
Add-DhcpServerv4Scope -Name 'TestNetwork' -StartRange '10.0.0.2' -EndRange '10.0.0.254' -SubnetMask '255.255.255.0' -Description 'Network for testlab A' -LeaseDuration (New-TimeSpan -Days 8) -Type "Both"


$DHCPScope = @{
    Name          = 'TestNetwork'
    StartRange    = '10.0.0.2'
    EndRange      = '10.0.0.254'
    SubnetMask    = '255.255.255.0'
    Description   = 'Network for testlab A'
    LeaseDuration = (New-TimeSpan -Days 8)
    Type          = "Both"
}
Add-DhcpServerv4Scope @DHCPScope


# Splatting optional values
$CIMParams = @{
    ClassName = 'Win32_Bios'
    ComputerName = $ComputerName
}

if($Credential)
{
    $CIMParams.Credential = $Credential
}

Get-CIMInstance @CIMParams


# Adding hashtables
$person += @{Zip = '78701'}


# Nested hashtables
$person = @{
    name = 'Kevin'
    age  = 37
}
$person.location = @{}
$person.location.city = 'Irvine'
$person.location.state = 'CA'


$person = @{
    name = 'Kevin'
    age  = 37
    location = @{
        city  = 'Irvine'
        state = 'CA'
    }
}

$person.location.city

# more nesting
$people = @{
    Kevin = @{
        age = 37
        city = 'Irvine'
    }
    Alex = @{
        age  = 9
        city = 'Irvine'
    }
}

$people.Kevin.age
$people.Kevin['city']
$people['Alex'].age
$people['Alex']['city']


# Walking the list
foreach($name in $people.keys)
{
    $person = $people[$name]
    '{0}, age {1}, is in {2}' -f $name, $person.age, $person.city
}


# Looking at nested hashtables
$people

$people | ConvertTo-JSON


# Creating objects
$person = [pscustomobject]@{
    name = 'Kevin'
    age  = 36
}
$person


# late casting
$person = @{
    name = 'Kevin'
    age  = 36
}

[pscustomobject]$person


# Saving to CSV
$person | ForEach-Object{ [pscustomobject]$PSItem } | 
    Export-CSV -Path $path


# Saving nested hashtable to file
$people | ConvertTo-JSON | Set-Content -Path $path
$people = Get-Content -Path $path -Raw | ConvertFrom-JSON


# Convert JSON to Hashtable
[Reflection.Assembly]::LoadWithPartialName("System.Web.Script.Serialization")
$JSSerializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
$JSSerializer.Deserialize($json,'Hashtable')


# Read directly from a file
$content = Get-Content -Path $Path -Raw -ErrorAction Stop
$scriptBlock = [scriptblock]::Create( $content )
$scriptBlock.CheckRestrictedLanguage( $allowedCommands, $allowedVariables, $true )
$hashtable = ( & $scriptBlock ) 


# Keys are just strings
$person = @{
    'full name' = 'Kevin Marquette'
    '#' = 3978
}
$person['full name']

$person.'full name'

$key = 'full name'
$person.$key



# Group-Object as hashtable
Get-ChildItem

$files = Get-ChildItem | Group-Object -AsHashTable -Property Name
$files

$files['Part1.ps1'].fullname

