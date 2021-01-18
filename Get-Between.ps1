[CmdletBinding()]
Param (
	[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
	$List,
	[Parameter(Mandatory)]
	[ArgumentCompleter( {
		($List | Get-Member -MemberType NoteProperty).Name
	} )]
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
		$min = ($List.$NotePropertyName | Measure-Object -Minimum).Minimum;
		$max = ($List.$NotePropertyName | Measure-Object -Maximum).Maximum
	}
	Process {
		If ($XorNotBetween) {
			$List.Where({$_.$NotePropertyName -in ($min, $max)})
		} else {
			$List.Where({$_.$NotePropertyName -notin ($min, $max)})
		}
	}
	End {
	}
}


Get-Between $List $NotePropertyName

# [System.Management.Automation.Language.Parser]::ParseInput($MyInvocation.MyCommand.ScriptContents, [ref]$null, [ref]$null)
