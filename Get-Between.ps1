<#
[CmdletBinding()]
Param (
	[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
	$List,
	[Parameter(Mandatory)]
	[string] $NotePropertyName,
	[switch] $XorNotBetween
)
#>
function Get-Between{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory, ValueFromPipeline, Position = 0)]
		[System.Object]$List,
		[Parameter(Mandatory, Position = 1)]
		# [ArgumentCompletions({([ref]$List | Get-Member -MemberType NoteProperty).Name})]
		[string] $NotePropertyName,
		[switch] $XorNotBetween
	)
	
	Begin {
		$min = ($List.$NotePropertyName | Measure-Object -Minimum).Minimum
		$max = ($List.$NotePropertyName | Measure-Object -Maximum).Maximum
	} Process {
		If ($XorNotBetween) {
			Write-Output $List.Where({$_.$NotePropertyName -in ($min, $max)})
		} else {
			Write-Output $List.Where({$_.$NotePropertyName -notin ($min, $max)})
		}
	} End {
	}
}

$GetNotePropertyNameCompleter = {
	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
	Return ($fakeBoundParameter["List"] | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
}

Register-ArgumentCompleter -CommandName Get-Between -ParameterName NotePropertyName -ScriptBlock $GetNotePropertyNameCompleter

<#
$ScriptBlock = [scriptblock]::Create( {
		param ( $CommandName,
			$ParameterName,
			$WordToComplete,
			$CommandAst,
			$FakeBoundParameters )
 
		$NotePropertyNames = $List | Get-Member -MemberType NoteProperty
		$NotePropertyNames.Name | ForEach-Object { $_ }
	})
 
Register-ArgumentCompleter -CommandName Get-Between -ParameterName NotePropertyName -ScriptBlock $ScriptBlock

<##>
#>