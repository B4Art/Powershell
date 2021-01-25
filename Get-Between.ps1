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
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
		[System.Object]$List,
		[Parameter(Mandatory, Position = 1)]
		[ValidateScript( {
			param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
			($fakeBoundParameter["List"] | Get-Member -MemberType NoteProperty).Where( { $_.Name -like "$wordToComplete*" }).ForEach( { [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name) }) 
		}) ]
		[string] $NotePropertyName,
		[Parameter(Position = 2)]
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
<#
$GetNotePropertyNameCompleter = {
	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
	($fakeBoundParameter["List"] | Get-Member -MemberType NoteProperty).Where( { $_.Name -like "$wordToComplete*" }).ForEach( { [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name) })
}

Register-ArgumentCompleter -CommandName Get-Between -ParameterName NotePropertyName -ScriptBlock $GetNotePropertyNameCompleter
# Register-ArgumentCompleter -ParameterName NotePropertyName -ScriptBlock $GetNotePropertyNameCompleter
#>