

$content = [string](Get-Content -Raw $args[0])
# $content
$lines = $content.Split("`n")
$maxLength = 0
foreach ($l in $lines) {
    # $l = $l.Replace("`n", "")
    if ($l -match '(.*?)\s*;(.*)') {
        if ($Matches[2].Trim().Length -gt 0) {
            $maxLength = [math]::max($Matches[1].TrimEnd().Length, $maxLength)            
        }
    }
}
# $lines | ConvertTo-Json
foreach ($l in $lines) {
    if ($l -match '^(\s*)([A-Za-z0-9_]{1,7})\s+([#$A-Za-z0-9_\-\(\)\.]{1}.*)$') {
        $l = "$($Matches[1])$($Matches[2].PadRight(8, ' '))$($Matches[3])"
    }

    if (($l -match '(.*?)\s*;(.*)') -and ($Matches[1].Length -gt 0)) {
        $left = $Matches[1]
        $comment = $Matches[2]

        Write-Host "$($left.PadRight($maxLength, ' ')) ; $($comment.Trim())"
    }
    else {
        Write-Host $l.TrimEnd()
    }
}