# null on left hand side
$person = @{
    name = 'Kevin'
    age  = 37
}

if ( $person.age -ne $null ) {'...'}

if ( $null -ne $person.age) {'...'}

if ( $null -ne $hashtable[$key]) {'...'}



# fun with null
$data = @(1, 0, $null, $null, @())

if ($data) {'True statement'}
if ($data -eq 1) {'True statement'}
if ($data -eq 0) {'True statement'}
if ($data -ne 1) {'True statement'}
if ($data -ne 0) {'True statement'}

if ($data -ne $null) {'True statement'}
if ($data -eq $null) {'True statement'}

if ($null -ne $data) {'True statement'}
if ($null -eq $data) {'True statement'} 
else {'False statement'}

# Empty collection
if (@() -eq $null) { 'true' } else { 'false' }
if (@() -ne $null) { 'true' } else { 'false' }

if ($null -ne @()) { 'true' } else { 'false' }
if ($null -eq @()) { 'true' } else { 'false' }

