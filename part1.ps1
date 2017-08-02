# Introduction to hashtables
# Basic Arrays and Collections
$array = @(10,11,12,13,15,17,19)

$array[0]
$array[1]

$array | ForEach-Object {$_ * 2}




$array[1] = 33
$array[1]


$array = @(
    'zero',
    'one',
    'two',
    'three'
)

$array[0]
$array[2]


# What is a hashtable?

<# Technical description
        A hashtable is a data structure much like an array, 
        except you store each value (object) using a key. 
        It is a basic key/value store.
 #>


# Create a hashtable
$ageList = @{}

$key = 'Kevin'
$value = 37
$ageList.add( $key, $value )
$ageList

$ageList.add( 'Alex', 9 )

$ageList.item('Kevin')


# Bracket assessors. Use key as index
$ageList['Kevin']
$ageList['Alex']


# Use Bracket to create a hashtable
$ageList = @{}

$key = 'Kevin'
$value = 37
$ageList[$key] = $value

$ageList['Alex'] = 9


# Creating hashtables with values

$ageList = @{
    "Kevin" = 37
    "Alex"  = 9
}


# As a lookup table
$environments = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$env = 'QA'
$server = $environments[$env]


# Iterating hashtables
$ageList = @{
    "Kevin" = 37
    "Alex"  = 9
}

$ageList | Measure-Object

$ageList.count

$agelist.values

$agelist.keys


$ageList.keys | ForEach-Object{
    '{0} is {1} years old!' -f $PSItem, $ageList[$PSItem]
}

foreach($key in $ageList.keys)
{
    '{0} is {1} years old' -f $key, $ageList[$key]
}


# GetEnumerator()
$ageList.GetEnumerator() | ForEach-Object{
    '{0} is {1} years old!' -f $PSItem.key, $PSItem.value
}


# Bad Enumeration example: will throw error
$environments = @{
    Prod = 'SrvProd05'
    QA   = 'SrvQA02'
    Dev  = 'SrvDev12'
}

$environments.Keys | ForEach-Object {
    $environments[$PSItem] = 'SrvDev03'
} 

#solution
$environments.Keys.Clone() | ForEach-Object {
    $environments[$PSItem] = 'SrvDev03'
} 

$environments


# Hashtable as a collection of properties
# property based access
$ageList = @{}
$ageList['Kevin'] = 37
$ageList.Kevin = 37
$ageList.Alex = 9

# new example
$person = @{
    name = 'Kevin'
    age  = 37
}

$person.city = 'Irvine'
$person.state = 'CA'

# checking for keys and values
if( $person['age'] ){'...'}

if( $person[$key] -ne $null ){'...'}

if( $person.ContainsKey('age') ){'...'}


# removing keys
$person.remove('age')


# clearing keys
$person = @{}

$person.clear()

