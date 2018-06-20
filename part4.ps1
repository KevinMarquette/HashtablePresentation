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
$ServerInfo
$ServerPatches

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
}

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
}
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
}
Measure-Command {
    foreach ($num in 1..$batchSize)
    {
        $data['Name']
    }
}

#endregion

#region getEnumerator() no measurable difference
$batchSize = 100000
$hashtable = @{}
foreach ($num in 1..$batchSize)
{
    $hashtable[$num] = $num * 2
}
Measure-Command {
    foreach ($key in $hashtable.Keys)
    {
        $hashtable[$key] 
    }
}
Measure-Command {
    foreach ($item in $hashtable.GetEnumerator())
    {
        $item.value
    }
}
#endregion


#region pre-size 
$batchSize = 10000000
$empty = @{}
$presized = [System.Collections.Generic.Dictionary[string, string]]::new(($batchSize * 1.5))

Measure-Command {
    foreach ($num in 1..$batchSize)
    {
        $empty[$num] = $num * 2
    }
}
Measure-Command {
    foreach ($num in 1..$batchSize)
    {
        $presized[$num] = $num * 2
    }
}
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