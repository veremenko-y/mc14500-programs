$curPath = Get-Location
$env:path += ";$curPath\cc65\"
$programsOutPath = "out"

Remove-Item "${programsOutPath}/*" -Recurse -Force -Confirm:$false  | Out-Null

function Compile($type) {
    "# Compiling $type programs"

    $programs = Get-ChildItem "$type/*.s" | Select-Object -ExpandProperty Name
    New-Item -Type Directory "${programsOutPath}/$type"  | Out-Null
    foreach ($program in $programs)
    {    
        $p = [System.IO.Path]::GetFileNameWithoutExtension($program)
        "Compiling $p"
        Invoke-Expression "ca65 -g $type/$p.s -o ${programsOutPath}/$type/$p.o -l ${programsOutPath}/$type/$p.lst --list-bytes 0"
        Invoke-Expression "ld65 -o ${programsOutPath}/$type/$p.bin -Ln ${programsOutPath}/$type/$p.labels -m ${programsOutPath}/$type/$p.map -C $type/system.cfg ${programsOutPath}/$type/$p.o"
    }
}

Compile "SBC1"

"*** DONE ***"