#region Data setup
#https://github.com/dfinke/NameIT
$count = 5
$names = Invoke-Generate "Server-###" -Count $count

$ServerInfo = $names | % {
    [pscustomobject]@{
        ComputerName = $_
        Owner        = Invoke-Generate "[person]"
        Phone        = Invoke-Generate "###-###-####"
    }
} | Sort Owner

$ServerPatches = $names | % {
    [pscustomobject]@{
        ComputerName = $_
        LastUpdate   = Invoke-Generate "[randomdate]"
        Status       = Invoke-Generate '[status]' -CustomData @{
            Status = echo Secure Unpatched Unsecure
        }
    }
} | Sort ComputerName
#endregion
# Performance

#endregion

#region Joining 2 CSVs
$ServerInfo | Out-GridView
$ServerPatches | Out-GridView

foreach ($server in $ServerInfo)
{
    $patchInfo = $ServerPatches | 
        Where ComputerName -eq $server.ComputerName

    [pscustomobject]@{
        ComputerName = $server.ComputerName
        Owner        = $server.owner
        Status       = $patchInfo.Status
        #...
    }
}

$opps = 0
foreach ($server in $ServerInfo)
{
    foreach ($patchInfo in $ServerPatches)
    {
        if ($patchInfo.ComputerName -eq $server.ComputerName)
        {
            [pscustomobject]@{
                ComputerName = $server.ComputerName
                Owner        = $server.owner
                Status       = $patchInfo.Status
                #...
            }
        }
        else 
        {
            $opps += 1
            Write-Host "Wasted opperation: $opps" -ForegroundColor Red   
        }
    }    
}

# Now with lookup tables
$lookup = $ServerPatches | 
    Group-Object -AsHashTable -Property ComputerName -AsString

foreach ($server in $ServerInfo)
{
    $patchInfo = $lookup[$server.ComputerName]
    
    [pscustomobject]@{
        ComputerName = $server.ComputerName
        Owner        = $server.owner
        Status       = $patchInfo.Status
        #...
    }
} 

#region csv merge Measure-Command
Measure-Command {
    foreach ($server in $ServerInfo)
    {
        $patchInfo = $ServerPatches | 
            Where ComputerName -eq $server.ComputerName
    
        [pscustomobject]@{
            ComputerName = $server.ComputerName
            Owner        = $server.owner
            Status       = $patchInfo.Status
            #...
        }
    } 
} | Select TotalMilliseconds

Measure-Command {
    $lookup = $ServerPatches | 
        Group-Object -AsHashTable -Property ComputerName -AsString

    foreach ($server in $ServerInfo)
    {
        $patchInfo = $lookup[$server.ComputerName]
        
        [pscustomobject]@{
            ComputerName = $server.ComputerName
            Owner        = $server.owner
            Status       = $patchInfo.Status
            #...
        }
    }
} | Select TotalMilliseconds
#endregion
#endregion

# Raw Performance
#region Proprty access vs Index access

$data = @{
    Name = 'Sample'
}
$batchSize = 1000000

Measure-Command {
    foreach ($num in 1..$batchSize)
    {
        $data.Name
    }
} | Select TotalMilliseconds
Measure-Command {
    foreach ($num in 1..$batchSize)
    {
        $data['Name']
    }
} | Select TotalMilliseconds

#endregion


#region C# interop
function test-function
{
    [CmdletBinding()]
    Param(
        [System.Collections.IDictionary]
        $Hashtable
    )
    #...
}
#endregion

# Bonus / Edge cases

# Why would I ever use the enumerator?
#   When 'Keys' is a key
$configData = @{
    Keys = 'none'
    Values = 'none'
}

foreach ($key in $configData.Keys)
{
    '[{0}] is [{1}]' -f $key, $configData[$key]
}

foreach ( $enumerator in $configData.GetEnumerator() )
{
    '[{0}] is [{1}]' -f $enumerator.key, $enumerator.value
}
