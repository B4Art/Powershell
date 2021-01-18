[CmdletBinding()]
Param (
	[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
	$List,
	[Parameter(Mandatory)]
	[string] $NotePropertyName,
	[switch] $XorNotBetween
)

function Get-Between{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
		$List,
		[Parameter(Mandatory)]
		[string] $NotePropertyName,
		[switch] $XorNotBetween
	)
	Begin {
		$min = ($List.$NotePropertyName | Measure-Object -Minimum).Minimum
		$max = ($List.$NotePropertyName | Measure-Object -Maximum).Maximum
	}
	Process {
		If ($XorNotBetween) {
			Write-Output $List.Where({$_.$NotePropertyName -in ($min, $max)})
		} else {
			Write-Output $List.Where({$_.$NotePropertyName -notin ($min, $max)})
		}
	}
	End {
	}
}

$scriptblock = {
	param($commandName, $parameterName, $stringMatch)
	($List | Get-Member -MemberType NoteProperty).Name
}

Register-ArgumentCompleter -CommandName Get-Between -ParameterName NotePropertyName -ScriptBlock $scriptBlock
