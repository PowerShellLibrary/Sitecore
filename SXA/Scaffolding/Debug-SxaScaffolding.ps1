# Constants - start
$key_Cmdlet = "Cmdlet ";
$key_Begin = " - Begin";
$key_End = " - End";
$key_Process = " - Process";
# Constants - end

function Remove-Keyword {
    param ([string]$line, [string]$key)
    $line.Replace($key_Cmdlet, [string]::Empty).Replace($key, [string]::Empty).Replace("-", "_");
}

function Test-KeywordLine {
    param ([string]$line, [string]$key)
    $line.StartsWith($key_Cmdlet) -and $line.EndsWith($key)
}

function Convert-FromOutStreamToXML {
    param ($streamEntries)
    [System.Collections.ArrayList]$lines = New-Object -TypeName "System.Collections.ArrayList"
    $cmdletCount = 0
    $cmdletEndingCount = 0
    for ($index = 0; $index -lt $streamEntries.Count; $index++) {
        $temp = $streamEntries[$index];
        if ($temp.GetType().Name -eq "VerboseRecord") {
            $line = $temp.Message
            if ($line.StartsWith($key_Cmdlet) -eq $false) {
                $line = "<message value=`"$line`" />";
            }
            else {
                if (Test-KeywordLine $line $key_Begin) {
                    $cmdletCount++
                    $line = Remove-Keyword $line $key_Begin
                    $line = "<cmdlet name=`"$line`">";
                }
                if (Test-KeywordLine $line $key_End) {
                    $cmdletEndingCount++
                    $line = Remove-Keyword $line $key_End
                    $line = "</cmdlet>";
                }
                if (Test-KeywordLine $line $key_Process) {
                    $line = Remove-Keyword $line $key_Process
                    $line = "<process_$line />";
                }
            }
        }
        if ($temp.GetType().Name -eq "ErrorRecord") {
            $message = $temp.Exception.Message
            $cmdName = $temp.InvocationInfo.MyCommand.Name
            $errorLine = $temp.InvocationInfo.Line.Replace("`n", ", ").Replace("`r", ", ").TrimStart(" ").TrimEnd(" ")
            $offsetInLine = $temp.InvocationInfo.OffsetInLine
            $scriptLineNumber = $temp.InvocationInfo.ScriptLineNumber
            $line = @"
            <error script="$cmdName" line="$scriptLineNumber" char="$offsetInLine">
                <message value="$message" />
                <line value="$errorLine" />
            </error>
"@
        }
        $lines.Add($line) | Out-Null
    }
    while ($cmdletCount -gt $cmdletEndingCount) {
        $cmdletEndingCount++
        $lines.Add("</cmdlet>") | Out-Null
    }
    $lines
}


$outStream = $( . {
        # CODE TO DEBUG GOES HERE
    } | Out-Null) 2>&1 4>&1

$lines = Convert-FromOutStreamToXML $outStream
Out-Download -Name "log.xml" -InputObject ([string[]]$lines)