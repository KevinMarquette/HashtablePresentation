# Introduction to hashtables
# Basic Arrays and Collections
$array = @(10, 11, 12, 13, 15, 17, 19)

$array[0]
$array[1]

$array | ForEach-Object {$PSItem * 2}

$array[1] = 33
$array[1]


$array = @(
    'zero'
    'one'
    'two'
    'three'
)

$array[0]
$array[2]


# What is a hashtable?

<# Technical description
    A hashtable is a data structure much like an array, 
    except you store each value (object) using a key. 
    It is a basic key/value store.
    Like classic C# Dictionary collection.
 #>


# Create a hashtable
$ageList = @{}

$key = 'Kevin'
$value = 40
$ageList.add( $key, $value )
$ageList

$ageList.add( 'Alex', 13 )

$ageList.item('Kevin')


# Bracket assessors. Use key as index
$ageList['Kevin']
$ageList['Alex']


# Use Bracket to update a hashtable
$ageList = @{}

$key = 'Kevin'
$value = 40
$ageList[$key] = $value

$ageList['Alex'] = 13
$ageList


# Creating hashtables with values
$ageList = @{
    "Kevin" = 40
    "Alex"  = 13
}

# Without using quotes for key names
$ageList = @{
    Kevin = 40
    Alex  = 13
}


# As a lookup table
$serverConfig = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$env = 'QA'
$server = $serverConfig[$env]
$server


# Multi-selection
$serverConfig['DEV', 'QA']

$env = 'DEV', 'QA'
$serverConfig[$env]

# null value for misses
$null -eq $serverConfig['MissingEnvironment']


# Iterating hashtables, walking the list
$serverConfig = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$serverConfig | Measure-Object | 
    Select-Object Count

$serverConfig.Count
    
$serverConfig | Get-Member

$serverConfig.Values

$serverConfig.Keys

# $PSItem is also $_
$serverConfig.Keys | ForEach-Object {
    '{0} server is {1}' -f $PSItem, $serverConfig[$PSItem]
}

foreach ($key in $serverConfig.Keys)
{
    '{0} server is {1}' -f $key, $serverConfig[$key]
}


# GetEnumerator()
$serverConfig.GetEnumerator() | Get-Member
$serverConfig.GetEnumerator() | Measure-Object | 
    Select-Object Count


$serverConfig.GetEnumerator() | ForEach-Object {
    '{0} server is {1}' -f $PSItem.key, $PSItem.value
}

foreach ( $enumerator in $serverConfig.GetEnumerator() )
{
    '{0} server is {1}' -f $enumerator.key, $enumerator.value
}

# Bad Enumeration example: will throw error
$serverConfig = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$serverConfig.Keys | ForEach-Object {
    $serverConfig[$PSItem] = 'SrvDev03'
} 
# An error occurred while enumerating through a collection: 
# Collection was modified; enumeration operation may not execute.

foreach ($key in $serverConfig.Keys) 
{
    $serverConfig[$key] = 'SrvDev03'
} 
# Collection was modified; enumeration operation may not execute.

# Solution
$serverConfig.Keys.Clone() | ForEach-Object {
    $serverConfig[$PSItem] = 'SrvDev03'
} 

foreach ($key in $serverConfig.Keys.Clone()) 
{
    $serverConfig[$key] = 'SrvDev03'
} 


# Hashtable as a collection of properties
# property based access
$ageList = @{}
$ageList.Kevin = 40
$ageList.Alex  = 13
$ageList

# new example
$person = @{
    name = 'Kevin'
    age  = 40
}

$person.city = 'Bellevue'
$person.state = 'WA'
$person

# checking for keys and values
if ( $person.age ) {'...'}

if ( $person.age -ne $null ) {'...'}
if ( $null -ne $person.age ) {'...'}

if ( $person.Contains('age') ) {'...'}
if ( $person.ContainsKey('age') ) {'...'}


# removing keys
$person.remove('age')
$person

# clearing keys
$person = @{}

$person.clear()
