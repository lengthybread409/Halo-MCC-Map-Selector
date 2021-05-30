# Process Game files



# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

function HReach{
    Write-Host "Creating Map List, Please wait."
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\R\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem ".\haloreach\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\Map\*.mvar" -File)
    }
    $map_ls = @()
    foreach($map in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0xc0,64)
        $ended = $true
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),448,256)
        $ended = $true
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_]}
            }
        }
        
        #base
        $base = "Unknown"
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x6C,0x6d]),0)
        switch($temp){
    3006{$base = "Forge World"}
    1000{$base="Sword Base"}
    1020{$base="Countdown"}
    1035{$base="Boardwalk"}
    1040{$base="Zealot"}
    1055{$base="Powerhouse"}
    1080{$base="Boneyard"}
    1150{$base="Reflection"}
    1200{$base="Spire"}
    1500{$base="Condemned"}
    1510{$base="Highlands"}
    2001{$base="Anchor 9"}
    2002{$base="Breakpoint"}
    2004{$base="Tempest"}

    -32437{$base="Penance"}
    10010{$base="Penance"}
    -18610{$base="Battle Canyon"}
    10020{$base="Battle Canyon"}
    -27397{$base="Ridgeline"}
    10030{$base="Ridgeline"}
    -12478{$base="Breakneck"}
    10050{$base="Breakneck"}
    10060{$base="High Noon"}
    20473{$base="High Noon"}
    -18379{$base="Solitary"}
    10070{$base="Solitary"}

    default{$base = $temp}
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
                G='R'
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\R\game_variants\*.bin" -File)
    }else{
        $list = (Get-ChildItem ".\haloreach\game_variants\*.bin" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\GameType\*.bin" -File)
    }
    $game_ls = @()
    foreach($gamemode in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0xc0,64)
        $ended = $true
        $adj = if($temp[0] -eq 0){1}else{0}
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$adj] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_+$adj]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0x1c0,256)
        $ended = $true
        $adj = if($temp[0] -eq 0){1}else{0}
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$adj] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_+$adj]}
            }
        }
        
        #base
        $base = "Unknown"
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $game_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$gamemode].Name
                Discription = $Discription.trim()
                Base = $base
                G='R'
            }
        }
        }catch{
            Write-Host -ForegroundColor Red "ERROR with $($list[$gamemode].name)"
        }
    }
    $Global:gamemodes = $game_ls

    return $true
}

function H2{
    Write-Host "Creating Map List, Please wait."
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\2\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem "./groundhog\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\Map\*.mvar" -File)
    }
    $map_ls = @()
    foreach($map in 0..($list.Count-1)){try{

        #base
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x7c,0x7d]),0)
        switch($temp){
    -28754{$base="Skyward";$start=0xa1}
    -20564{$base="Lockdown";$start=0xbd}
    -12374{$base="Zenith";$start=0xbd}
    -12369{$base="Awash";$start=0xa1}
    -4179{$base="Bloodline";$start=0xbd}
    4012{$base="Stonetown";$start=0xbd}
    12207{$base="Nebula";$start=0xa1}
    20397{$base="Warlord";$start=0xbd}
    28587{$base="Shrine";$start=0xbd}
    28592{$base="Remnant";$start=0xbd}
    default{$base = $temp}
        }

        $temp = [System.IO.File]::ReadAllBytes($list[$map])[$start..($start + 327)]
        $name_T = 0;$aaa = 0;$aa=@{}
        0..($temp.Count-3) | %{
            if(($_ % 2)){
                if([int]$temp[$_+1]  -eq 0 -and [int]$temp[$_+2] -eq 0 -and $name_T -eq 0){
                    $name_T = 1
                    $aa['a'] = $temp[0..($_)]
                    $aaa=$_+3
                }
                elseif([int]$temp[$_-1] -eq 0xd3 -and [int]$temp[$_] -eq 0xff -and $name_T -eq 1){
                    $name_T = 2
                    $aa['b'] = $temp[$aaa..($_-4)]
                }
            }
        }

        $name = ""
        0..($aa['a'].Length-1) | %{
            if(($_ % 2)){
                #Write-Host "$_ $($aa['a'][$_]),$($aa['a'][$_-1]) $([bitconverter]::ToInt16(($($aa['a'][$_]),$($aa['a'][$_-1])),0)) $(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                $name +=  "$(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
            }
        }

        $Discription = ""
        0..($aa['b'].Length-1) | %{
            if(($_ % 2)){
                #Write-Host "$_ $($aa['b'][$_]),$($aa['b'][$_-1]) $([bitconverter]::ToInt16(($($aa['b'][$_]),$($aa['b'][$_-1])),0)) $(H2Encode(($aa['b'][$_],$aa['b'][$_-1])))"
                $Discription +=  "$(H2Encode(($aa['b'][$_],$aa['b'][$_-1])))"
            }
        }
        
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
                G='2'
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\2\game_variants\*.bin" -File)
    }else{
        $list = (Get-ChildItem "./groundhog\game_variants\*.bin" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\GameType\*.bin" -File)
    }
    $game_ls = @()
    foreach($gamemode in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0xc0,64)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_+$ssstart]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0x1c0,256)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_+$ssstart]}
            }
        }
        
        #base
        $base = "Unknown"
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$gamemode])[0x6c,0x6d]),0)
        if($temp -eq 0){
            $temp = ([System.IO.File]::ReadAllBytes($list[$gamemode])[0x7c])
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $game_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$gamemode].Name
                Discription = $Discription.trim()
                Base = $base
                G='2'
            }
        }
        }catch{
            Write-Host -ForegroundColor Red "ERROR with $($list[$gamemode].name)"
        }
    }
    $Global:gamemodes = $game_ls
    return $true
}
function H2Encode($num){
    $x = [bitconverter]::ToInt16(($num[0],$num[1]),0)
    if ($x -lt 127){
        if($num[1] -eq 1){
            return [char]($x -shr 2)
        }
        else{
            return [char]($x)
        }
    }
    else{
        return [char]($x -shr 2)
    }
}

function H3{
    Write-Host "Creating Map List, Please wait."
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\3\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem "./halo3\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\halo3\Map\*.mvar" -File)
    }
    $map_ls = @()
    foreach($map in 0..($list.Count-1)){try{

        #Name
        $easy_way=0
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x48,190)
        if([int]$temp[0]+[int]$temp[1]+[int]$temp[2]+[int]$temp[3] -eq 0){
            $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x94,190)
            $easy_way = 1
        }
        $shift = 0;
        foreach ($shift in 0..10){
            if([int]$temp[$shift+1] + [int]$temp[$shift+3] + [int]$temp[$shift+5] -eq 0){
                break
            }
        }
        
        $name = "";$Discription="";
        if($easy_way -eq 0){
            foreach ($index in $shift..($shift + 32)){
                if(($index - $shift) % 2 -eq 0){
                    if($temp[$index] -eq 0){
                        break
                    }else{
                        $name+=$temp[$index]
                    }
                }
            }
            $disc_start = $true
            foreach ($index in ($shift+31)..($shift + 31 +128)){
                if($disc_start -and $temp[$index] -eq 0){
                    continue
                }else{$disc_start = $false}
                if($temp[$index] -eq 0){
                    break
                }else{
                    $Discription+=$temp[$index]
                }
            }
        }else{
            $Name_To_Discr = $false
            foreach ($index in $shift..($temp.length-2+$shift)){
                if(($index % 2) -or $Name_To_Discr){
                    #Write-Host $index $Name_To_Discr $temp[$index]
                    if($temp[$index] -eq 0){
                        if($Name_To_Discr){
                            $easy_way = $index+0x95
                            break
                        }else{
                            $Name_To_Discr = $true
                        }
                    }else{
                        if($Name_To_Discr){
                            $Discription += $temp[$index]
                        }else{
                            $name += $temp[$index]
                        }
                    }
                }
            }
        }
        
        #base
        $base = "Unknown";$id = 0;
        if ($easy_way -eq 0){
            $id = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x122,0x123]),0)
        }
        else{
            #$id = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[$type+0x3d,$type+0x3e]),0)
            $temp = [System.IO.File]::ReadAllBytes($list[$map])[$easy_way..($easy_way+0x50)]
            1..($temp.Count-5) |  %{
                #Write-Host $($temp[$_+2]) $($temp[$_+3]) $($temp[$_+4])
                if([int]$temp[$_+2]  -eq 0x07 -and [int]$temp[$_+3] -eq 0xff -and [int]$temp[$_+4] -eq 0xf8){
                    $id = [bitconverter]::ToInt16(($temp[$_],$temp[$_+1]),0)
                }
            }
        }
        switch($id){
    -22521{$base="Assembly"}
    -5631{$base="Assembly"}

    -10751{$base="Avalanche"}
    22535{$base="Avalanche"}
    
    8200{$base="Blackout"}
    2050{$base="Blackout"}
    
    -0001{$base="Citadel"}
    -7166{$base="Citadel"}

    22530{$base="Cold Storage"}
    24585{$base="Cold Storage"}
    
    -20476{$base="Construct"}
    11265{$base="Construct"}
    
    30725{$base="Epitaph"}
    24065{$base="Epitaph"}

    -8191 {$base="Foundry"}
    -32761{$base="Foundry"}
    
    19970{$base="Ghost Town"}
    14345{$base="Ghost Town"}

    16385{$base="Guardian"}
    5{$base="Guardian"}
    
    -0001{$base="Heretic"}
    16395{$base="Heretic"}

    13825{$base="High Ground"}
    -10236{$base="High Ground"}
    
    18945{$base="Isolation"}
    10245{$base="Isolation"}

    7680{$base="Last Resort"}
    30720{$base="Last Resort"}
    
    -18431{$base="Longshore"}
    -8186{$base="Longshore"}
    
    -4091{$base="Narrows"}
    31745{$base="Narrows"}
    
    -3071{$base="Orbital"}
    -12281{$base="Orbital"}
    
    17410{$base="Rat's Nest"}
    4105{$base="Rat's Nest"}
    
    -9726{$base="Sandbox"}
    26635{$base="Sandbox"}

    -28671{$base="Sandtrap"}
    16390{$base="Sandtrap"}

    26625{$base="Snowbound"}
    -24571{$base="Snowbound"}

    -26111{$base="Standoff"}
    26630{$base="Standoff"}

    -31231{$base="The Pit"}
    6150{$base="The Pit"}
    
    20485{$base="Valhalla"}
    21505{$base="Valhalla"}
    default{$base = $id}
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
                G='3'
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\3\game_variants\*.bin" -File)
    }else{
        $list = (Get-ChildItem "./halo3\game_variants\*.bin" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\halo3\GameType\*.bin" -File)
    }
    $game_ls = @()
    foreach($gamemode in 0..($list.Count-1)){try{

        #Name
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0x48,190)
        $shift = 0;
        foreach ($shift in 0..10){
            if([int]$temp[$shift+1] + [int]$temp[$shift+3] + [int]$temp[$shift+5] -eq 0){
                break
            }
        }
        
        $name = "";$Discription="";
        foreach ($index in $shift..($shift + 32)){
            if(($index - $shift) % 2 -eq 0){
                if($temp[$index] -eq 0){
                    break
                }else{
                    $name+=$temp[$index]
                }
            }
        }
        $disc_start = $true
        foreach ($index in ($shift+31)..($shift + 31 +128)){
            if($disc_start -and $temp[$index] -eq 0){
                continue
            }else{$disc_start = $false}
            if($temp[$index] -eq 0){
                break
            }else{
                $Discription+=$temp[$index]
            }
        }

        
        #base
        $base = "Unknown"

        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $game_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$gamemode].Name
                Discription = $Discription.trim()
                Base = $base
                G='3'
            }
        }
        }catch{
            Write-Host -ForegroundColor Red "ERROR with $($list[$gamemode].name)"
        }
    }
    $Global:gamemodes = $game_ls

    return $true
}

function H4{
    Write-Host "Creating Map List, Please wait."
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\4\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem ".\halo4\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo4\Map\*.mvar" -File)
    }
    $map_ls = @()
    foreach($map in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0xc0,64)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_+$ssstart]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x1c0,256)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_+$ssstart]}
            }
        }
        
        #base
        $base = "Unknown"
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x6c,0x6d]),0)
        if($temp -eq 0){
            $temp = ([System.IO.File]::ReadAllBytes($list[$map])[0x7c])
        }
        switch($temp){
        #<#
    0{$base='Abandon'}
    0{$base='Abandon'}
    
    10210{$base='Adrift'}
    10210{$base='Adrift'}
    
    10085{$base='Complex'}
    0{$base='Complex'}
    
    0{$base='Daybreak'}
    0{$base='Daybreak'}
    
    10245{$base='Erosion'}
    6942{$base='Erosion'}
    27929{$base='Erosion'}
    
    10226{$base='Exile'}
    10226{$base='Exile'}
    
    14100{$base='Forge Island'}
    0{$base='Forge Island'}
    
    10102{$base='Harvest'}
    0{$base='Harvest'}

    10080{$base='Haven'}
    10080{$base='Haven'}

    10255{$base='Impact'}
    80{$base='Impact'}
    31250{$base='Impact'}
    
    13110{$base='Landfall'}
    13110{$base='Landfall'}
    
    10200{$base='Longbow'}
    10200{$base='Longbow'}
    
    10261{$base='Meltdown'}
    10261{$base='Meltdown'}
    
    0{$base='Monolith'}
    0{$base='Monolith'}
    
    0{$base='Outcast'}
    0{$base='Outcast'}

    13120{$base='Perdition'}
    81{$base='Perdition'}
    
    15000{$base='Pitfall'}
    15000{$base='Pitfall'}
    
    10091{$base='Ragnarok'}
    10091{$base='Ragnarok'}
    
    10256{$base='Ravine'}
    101{$base='Ravine'}
    
    0{$base='Shatter'}
    0{$base='Shatter'}
    
    13160{$base='Skyline'}
    13160{$base='Skyline'}
    
    0{$base='Solace'}
    0{$base='Solace'}
    
    15010{$base='Vertigo'}
    0{$base='Vertigo'}
    
    10252{$base='Vortex'}
    0{$base='Vortex'}
    
    0{$base='Wreckage'}
    0{$base='Wreckage'}

        #>
    default{$base = $temp}
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
                G='4'
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls

    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\4\game_variants\*.bin" -File)
    }else{
        $list = (Get-ChildItem ".\halo4\game_variants\*.bin" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo4\GameType\*.bin" -File)
    }
    $game_ls = @()
    foreach($gamemode in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0xc0,64)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_+$ssstart]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$gamemode]),0x1c0,256)
        if($temp[0] -eq 0){
            $ssstart = 1
        }else{
            $ssstart = 0
        }
        $ended = $true
        0..($temp.length-2-$ssstart) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_+$ssstart] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_+$ssstart]}
            }
        }
        
        #base
        $base = "Unknown"
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$gamemode])[0x6c,0x6d]),0)
        if($temp -eq 0){
            $temp = ([System.IO.File]::ReadAllBytes($list[$gamemode])[0x7c])
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $game_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$gamemode].Name
                Discription = $Discription.trim()
                Base = $base
                G='4'
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$gamemode].name)"
        }
    }
    $Global:gamemodes = $game_ls
    return $true
}

function f_change_game{
    #$conf = [System.Windows.MessageBox]::Show("Are you sure you want to change to $($Change_Game.Text)?",'Game input','YesNo')
    $conf = "Yes"
    if($conf -eq "Yes"){
        # $Change_Game.Text
        $Label1.Visible = $true
        $Label1.Text = "Generating Map List"
        if($Change_Game.Text -eq "Halo Reach"){
            $ret = HReach
            $Label1.Text = "Halo Reach Maps"
            $Label2.Text = "Halo Reach Gametypes"
        }
        elseif($Change_Game.Text -eq "Halo 2A"){
            $ret = H2
            $Label1.Text = "Halo 2A Maps"
            $Label2.Text = "Halo 2A Gametypes"
        }
        elseif($Change_Game.Text -eq "Halo 3"){
            $ret = H3
            $Label1.Text = "Halo 3 Maps"
            $Label2.Text = "Halo 3 Gametypes"
        }
        elseif($Change_Game.Text -eq "Halo 4"){
            $ret = H4
            $Label1.Text = "Halo 4 Maps"
            $Label2.Text = "Halo 4 Gametypes"
        }
        else{
            $Label1.Text = "Error with the selecting the game"
            write-host -ForegroundColor Red 'Ops Bad game.'
            return -1
        }

        $Map_Elements | %{$_.visible = $true}
        $Game_Elements | %{$_.visible = $true}
        $qu_1 | %{$_.visible = $True}
        $qu_2 | %{$_.visible = $True}
        $qu_3 | %{$_.visible = $True}
        $Next_Map.Visible = $Next_Game.Visible = $true

        $maps_filtered=@()
        $gamemodes_filtered=@()

        f_clear_map
        f_clear_game
    }
}
function f_move_stuff{

    #$a = [System.Windows.MessageBox]::Show('Do you want to include your AppData files?','Game input','YesNoCancel')
    $a = "Yes"
    if($a -eq "Cancel"){
        return
    }
    # Halo Reach
    try{
        mkdir -Path "./Master_List/R" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/R/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/R/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Reach folder. please ensure I can make folders" -ForegroundColor Red
        exit
    }
    try{
        Get-Item -Path "./haloreach/map_variants/*" -Exclude @("*beaver_creek_cl_031.mvar","*damnation_cl_031.mvar","*hang_em_high_cl_031.mvar","*headlong_cl_031.mvar","*hr_forgeWorld_asylum.mvar","*hr_forgeWorld_hemorrhage.mvar","*hr_forgeWorld_paradiso.mvar","*hr_forgeWorld_pinnacle.mvar","*hr_forgeWorld_theCage.mvar","*prisoner_cl_031.mvar","*timberland_cl_031.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/R/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./haloreach/game_variants/*" -Exclude @("*00_basic_editing_054.bin","*2nvasion_slayer_054.bin","*3nvasion_054.bin","*3nvasion_boneyard_054.bin","*3nvasion_dlc_054.bin","*3nvasion_spire_054.bin","*assault_054.bin","*assault_neutral_bomb_054.bin","*assault_one_bomb_054.bin","*ctf_054.bin","*ctf_1flag_054.bin","*ctf_multiteam_054.bin","*ctf_neutralflag_054.bin","*headhunter_054.bin","*headhunter_pro_054.bin","*hr_4v4_team_3plots_dmr_ar_500points_tu.bin","*hr_4v4_team_assault_dmr_ar_3points_tu.bin","*hr_4v4_team_crazyKing_dmr_ar_150points_tu.bin","*hr_4v4_team_headhunter_dmr_ar_50points_tu.bin","*hr_4v4_team_multiFlag_dmr_ar_3points_tu.bin","*hr_4v4_team_oddball_dmr_ar_150points_tu.bin","*hr_4v4_team_oneBomb_dmr_ar_3points_tu.bin","*hr_4v4_team_oneFlag_dmr_ar_4rounds_tu.bin","*hr_4v4_team_slayer_dmr_ar_50points_tu.bin","*hr_4v4_team_stockpile_dmr_ar_10points_tu.bin","*hr_4v4_team_territories_dmr_ar_4rounds_3min_tu.bin","*hr_ffa_juggernaut_ar_mag_150points_tu.bin","*hr_ff_classic_1set.bin","*hr_ff_generatorDefense_1set.bin","*hr_ff_gruntpocalypse_1round.bin","*hr_ff_rocketfight_1set.bin","*hr_ff_scoreAttack_1round.bin","*hr_ff_standard_1set.bin","*hr_ff_versus_2turns.bin","*infection_054.bin","*infection_safehavens_054.bin","*juggernaut_054.bin","*koth_054.bin","*koth_crazyking_054.bin","*oddball_054.bin","*race_054.bin","*rally_054.bin","*skeeball_default_054.bin","*slayer_054.bin","*slayer_classic_054.bin","*slayer_covy_054.bin","*slayer_pro_054.bin","*stockpile_054.bin","*SWAT_054.bin","*territories-3plot_054.bin","*territories-landgrab_054.bin","*territories_054.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/R/game_variants" -Force -ErrorAction Ignore
        }
        if($a -eq "Yes"){

            # Halo Reach local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\Map\*.mvar" -File)
            foreach($map in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($map.FullName)" -Destination "./Master_List/R/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo Reach local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($game.FullName)" -Destination "./Master_List/R/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/R'. please ensure I can move files" -ForegroundColor Red
        return -1
    }
    
    #<# Halo 2 A
    try{
        mkdir -Path "./Master_List/2" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/2/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/2/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Halo 2A folder. please ensure I can make folders" -ForegroundColor Red
        return -1
    }
    try{
        Get-Item -Path "./groundhog/map_variants/*"  -Exclude @("*bloodline_classic.mvar","*lockdown_classic.mvar","*remnant_classic.mvar","*shrine_classic.mvar","*stonetown_classic.mvar","*warlord_classic.mvar","*zenith_classic.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/2/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./groundhog/game_variants/*"  -Exclude @("*H2A_001_001_basic_editing_137.bin","*H2A_100_100_Slayer_BASE_TeamSlayer_137.bin","*H2A_100_150_Slayer_Pro_137.bin","*H2A_100_200_Slayer_FFA_137.bin","*H2A_100_250_Slayer_BR_137.bin","*H2A_100_300_Slayer_BR_FFA_137.bin","*H2A_100_350_Slayer_Elimination_137.bin","*H2A_100_400_Slayer_Phantom_Elimination_137.bin","*H2A_100_450_Slayer_Phantoms_137.bin","*H2A_100_500_Slayer_Team_Phantoms_137.bin","*H2A_100_550_Slayer_Rockets_137.bin","*H2A_100_600_Slayer_Snipers_137.bin","*H2A_100_650_Slayer_Team_Snipers_137.bin","*H2A_100_700_Slayer_Swords_137.bin","*H2A_100_750_Slayer_SWAT_137.bin","*H2A_100_800_Slayer_SWAT_Arsenal_137.bin","*H2A_200_100_CTF_BASE_MultiFlag_137.bin","*H2A_200_200_CTF_Classic_Flag_137.bin","*H2A_200_300_CTF_Classic_One_Flag_137.bin","*H2A_200_400_CTF_Classic_Tiny_137.bin","*H2A_200_500_CTF_One_Flag_137.bin","*H2A_200_600_CTF_Neutral_137.bin","*H2A_200_700_CTF_Gungoose_137.bin","*H2A_300_100_KOTH_Team_Crazy_King_137.bin","*H2A_300_200_KOTH_Crazy_King_137.bin","*H2A_300_300_KOTH_Team_King_137.bin","*H2A_300_400_KOTH_BASE_King_137.bin","*H2A_300_500_KOTH_Phantom_King_137.bin","*H2A_300_600_KOTH_Kill_From_The_Hill_137.bin","*H2A_400_100_ODDBALL_BASE_137.bin","*H2A_400_200_ODDBALL_Team_Ball_137.bin","*H2A_400_300_ODDBALL_Low_Ball_137.bin","*H2A_400_400_ODDBALL_Fiesta_137.bin","*H2A_400_500_ODDBALL_Swords_137.bin","*H2A_400_600_ODDBALL_Team_Swords_137.bin","*H2A_400_700_ODDBALL_Rockets_137.bin","*H2A_500_100_JUGGERNAUT_BASE_137.bin","*H2A_500_200_JUGGERNAUT_Ninjanaut_137.bin","*H2A_500_300_JUGGERNAUT_Phantom_Fodder_137.bin","*H2A_500_400_JUGGERNAUT_Dreadnaut_137.bin","*H2A_500_500_JUGGERNAUT_Multinaut_137.bin","*H2A_500_600_JUGGERNAUT_Nautacular_137.bin","*H2A_500_700_JUGGERNAUT_Juggernaut_Hunt_137.bin","*H2A_500_800_JUGGERNAUT_Nauticide_137.bin","*H2A_600_100_ASSAULT_BASE_MultiBomb_137.bin","*H2A_600_200_ASSAULT_Half_Time_137.bin","*H2A_600_300_ASSAULT_One_Bomb_137.bin","*H2A_600_400_ASSAULT_One_Bomb_Fast_137.bin","*H2A_600_500_ASSAULT_Blast_Resort_137.bin","*H2A_600_600_ASSAULT_Neutral_Bomb_137.bin","*H2A_700_100_TERRITORIES_BASE_3Plots_137.bin","*H2A_700_200_TERRITORIES_Incursion_137.bin","*H2A_700_300_TERRITORIES_Land_Grab_137.bin","*H2A_700_400_TERRITORIES_Gold_Rush_137.bin","*H2A_700_500_TERRITORIES_Control_Issues_137.bin","*H2A_700_600_TERRITORIES_Contention_137.bin","*H2A_700_700_TERRITORIES_Lockdown_137.bin","*H2A_800_100_INFECTION_BASE_137.bin","*H2A_800_200_INFECTION_Cadre_137.bin","*H2A_800_300_INFECTION_Flight_137.bin","*H2A_800_400_INFECTION_Hunted_137.bin","*H2A_900_100_RACE_BASE_137.bin","*H2A_900_200_RACE_Hornet_137.bin","*H2A_900_300_RACE_Rally_137.bin","*H2A_900_400_RACE_Gungoose_Gauntlet_137.bin","*H2A_900_500_RACE_Velocity_137.bin","*H2A_950_100_RICOCHET_BASE_137.bin","*H2A_950_200_RICOCHET_Half_Time_137.bin","*H2A_950_300_RICOCHET_Quickochet_137.bin","*H2A_950_400_RICOCHET_Multi_Team_137.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/2/game_variants" -Force -ErrorAction Ignore
        }
        if($a -eq "Yes"){

            # Halo 2 local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\Map\*.mvar" -File)
            foreach($map in $list){
                $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($map)[0x7c,0x7d]),0)
                switch($temp){
                    -28754{$base="Skyward";$start=0xa1}
                    -20564{$base="Lockdown";$start=0xbd}
                    -12374{$base="Zenith";$start=0xbd}
                    -12369{$base="Awash";$start=0xa1}
                    -4179{$base="Bloodline";$start=0xbd}
                    4012{$base="Stonetown";$start=0xbd}
                    12207{$base="Nebula";$start=0xa1}
                    20397{$base="Warlord";$start=0xbd}
                    28587{$base="Shrine";$start=0xbd}
                    28592{$base="Remnant";$start=0xbd}
                    default{$base = $temp}
                }
                $temp = [System.IO.File]::ReadAllBytes($map)[$start..($start + 327)]
                $name_T = 0;$aaa = 0;$aa=@{}
                0..($temp.Count-3) | %{
                    if(($_ % 2)){
                        if([int]$temp[$_+1]  -eq 0 -and [int]$temp[$_+2] -eq 0 -and $name_T -eq 0){
                            $name_T = 1
                            $aa['a'] = $temp[0..($_)]
                            $aaa=$_+3
                        }
                        elseif([int]$temp[$_-1] -eq 0xd3 -and [int]$temp[$_] -eq 0xff -and $name_T -eq 1){
                            $name_T = 2
                            $aa['b'] = $temp[$aaa..($_-4)]
                        }
                    }
                }
                #Name
                $name = ""
                0..($aa['a'].Length-1) | %{
                    if(($_ % 2)){
                        #Write-Host "$_ $($aa['a'][$_]),$($aa['a'][$_-1]) $([bitconverter]::ToInt16(($($aa['a'][$_]),$($aa['a'][$_-1])),0)) $(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                        $name +=  "$(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($map.FullName)" -Destination "./Master_List/2/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo 2 local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($game.FullName)" -Destination "./Master_List/2/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/2'. please ensure I can move files" -ForegroundColor Red
        return -1
    }
    #>#
    
    #<# Halo 3
    try{
        mkdir -Path "./Master_List/3" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/3/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/3/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Halo 3 folder. please ensure I can make folders"
        return -1
    }
    try{
        Get-Item -Path "./halo3/map_variants/*" -Exclude @("*h3_epitaph_epilogue_bruteshotFix.mvar","*h3_hardcoreConstruct.mvar","*h3_hardcoreConstruct_ts.mvar","*h3_hardcoreFoundry_amplified.mvar","*h3_hardcoreFoundry_onslaught.mvar","*h3_hardcoreGuardian.mvar","*h3_hardcoreHeretic.mvar","*h3_hardcoreHeretic_ffa.mvar","*h3_hardcoreNarrows.mvar","*h3_hardcorePit.mvar","*year2_sandtrap_sandtarp_012.mvar","*year2_snowbound_boundless_012.mvar","*year2_the_pit_pitstop_012.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/3/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./halo3/game_variants/*" -Exclude @("00_sandbox-0_010.bin","*assault-0_010.bin","*assault-1_010.bin","*assault-2_010.bin","*assault-3_010.bin","*ctf-0_010.bin","*ctf-1_010.bin","*ctf-2_010.bin","*ctf-3_010.bin","*h3_2v2_team_hardcoreSlayer_25kills.bin","*h3_4v4_hardcoreBall_250points.bin","*h3_4v4_hardcoreFlag_heretic_5points.bin","*h3_4v4_hardcoreFlag_narrows_3points.bin","*h3_4v4_hardcoreFlag_pit_3points.bin","*h3_4v4_hardcoreKing_250points.bin","*h3_4v4_hardcoreSlayer_50kills.bin","*h3_4v4_hardcoreSlayer_construct_50kills.bin","*h3_ffa_hardcoreSlayer_12min.bin","*infection-0_010.bin","*infection-1_010.bin","*infection-2_010.bin","*infection-3_010.bin","*juggernaut-0_010.bin","*juggernaut-1_010.bin","*juggernaut-2_010.bin","*king of the hill-0_010.bin","*king of the hill-1_010.bin","*king of the hill-2_010.bin","*oddball-0_010.bin","*oddball-1_010.bin","*oddball-2_010.bin","*oddball-3_010.bin","*oddball-4_010.bin","*slayer-0_010.bin","*slayer-1_010.bin","*slayer-2_010.bin","*slayer-3_010.bin","*slayer-4_010.bin","*territories-0_010.bin","*territories-1_010.bin","*territories-2_010.bin","*vip-0_010.bin","*vip-1_010.bin","*vip-2_010.bin","*vip-3_010.bin","braaaains_010.bin","grifball_010.bin","grifball_aerial_010.bin","grifball_mayan_010.bin","grifball_upthere_010.bin","pit_of_joy_010.bin","pit_of_lies_010.bin","rocket_race_010.bin","speed_demons_010.bin","vip_runforcover_010.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/3/game_variants" -Force -ErrorAction Ignore
        }
        if($a -eq "Yes"){

            # Halo 3 local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo3\Map\*.mvar" -File)
            foreach($map in $list){
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0x49,160)
                if([int]$temp[0] -eq 0){
                    $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0x95,160)
                    $type = 1
                }
                $name_T = 0;$aaa = 0;$aa=0;
                $name = "";$Discription="";
                0..($temp.length-2) | %{
                    if(!($_ % 2) -or ($name_T -eq 1)){
                        if([int]$temp[$_-1]  -eq 0 -and [int]$temp[$_] -eq 0 -and $name_T -eq 0){
                            $name_T = 1
                            $aaa = $_+1
                        }
                        elseif($temp[$_] -eq 0 -and $name_T -eq 1 -and $aa -eq 1){
                            $name_T = 2
                            foreach ($let in $temp[$aaa..($_-1)]) {$Discription += [char]$let}
                            if ($type -eq 1){$type = $_+0x95} 
                        }
                        if($name_T -eq 0){
                            $name += $temp[$_]
                        }
                        if($name_T -eq 1 -and $temp[$_] -ne 0 -and $aa -eq 0){
                            $aa = 1
                            $aaa = $_
                        }
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($map.FullName)" -Destination "./Master_List/3/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo 3 local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo3\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0x48,31)
                $ended = $true
                0..($temp.length-2) | %{
                    if(($temp[$_]) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($game.FullName)" -Destination "./Master_List/3/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/3'. please ensure I can move files" -ForegroundColor Red
        return -1
    }
    #>#
    
    #<# Halo 4
    try{
        mkdir -Path "./Master_List/4" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/4/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/4/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Halo 4 folder. please ensure I can make folders" -ForegroundColor Red
        return -1
    }
    try{
        Get-Item -Path "./halo4/map_variants/*" -Exclude @("grifballcourt.mvar","ca_forge_bonanza_relay.mvar","ca_forge_erosion_ascent.mvar","ca_forge_ravine_settler.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/4/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./halo4/game_variants/*" -Exclude @("H4_BASIC_EDITING_132.bin","H4_CTF_132.bin","H4_DOMINION_132.bin","H4_EXTRACTION_132.bin","H4_FLOOD_132.bin","H4_GOAL_132.bin","H4_GOAL_FORGE_132.bin","H4_Grifball_132.bin","H4_infinityrumble_8ffa_132.bin","H4_KOTH_132.bin","H4_ODDBALL_132.bin","H4_REGICIDE_132.bin","H4_SLAYER_132.bin","H4_SLAYER_ESCALATION_132.bin","H4_SWAT_132.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/4/game_variants" -Force -ErrorAction Ignore
        }
        if($a -eq "Yes"){
            # Halo 4 local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo4\Map\*.mvar" -File)
            foreach($map in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0xc0,64)
                if($temp[0] -eq 0){
                    $ssstart = 1
                }else{
                    $ssstart = 0
                }
                $ended = $true
                0..($temp.length-2-$ssstart) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_+$ssstart] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_+$ssstart]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($map.FullName)" -Destination "./Master_List/4/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo Reach local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo4\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0xc0,64)
                if($temp[0] -eq 0){
                    $ssstart = 1
                }else{
                    $ssstart = 0
                }
                $ended = $true
                0..($temp.length-2-$ssstart) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_+$ssstart] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_+$ssstart]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Copy-Item -LiteralPath "$($game.FullName)" -Destination "./Master_List/4/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/4'. please ensure I can move files" -ForegroundColor Red
        return -1
    }
    #>#

    $master_list_exist = $true

    return 0
}
function resize_form{
    $n_with = $Form.Width
    
    $temp = ($n_with - 35)/4

    $Change_Game.Width = $Move_Stuff.Width = $Next_Map.Width = $Next_Game.Width = $temp
    $Move_Stuff.Left = 10 + $temp
    $Next_Map.Left = 10 + ($temp*2)
    $Next_Game.Left = 10 + ($temp*3)

    $temp = ($n_with - 35)/6
    $Text_Map.Width = ($temp * 3)-50
    $Combo_Map.Width = ($temp * 4)-50
    $Add_Map.Width = $Search_Map.Width =$Random_Map.Width = $temp
    $Search_Map.Left = 10+(3*$temp)
    $Random_Map.Left = 10+(4*$temp)
    $Add_Map.Left = 10+(5*$temp)

    $Text_Game.Width = ($temp * 3)-50
    $Combo_Game.Width = ($temp * 4)-50
    $Add_Game.Width = $Search_Game.Width =$Random_Game.Width = $temp
    $Search_Game.Left = 10+(3*$temp)
    $Random_Game.Left = 10+(4*$temp)
    $Add_Game.Left = 10+(5*$temp)

    $Name_Map.width = $Disc_Map.width = $n_with - 35
    $File_Map.left = $n_with - 235

    $Name_Game.width = $Disc_Game.width = $n_with - 35
    $File_Game.left = $n_with - 235

    $Name_Map_Q1.Width = $Name_Game_Q1.Width = $temp*4
    $Base_Map_Q1.Width = $Base_Game_Q1.Width = $temp*2
    $Disc_Map_Q1.Width = $Disc_Game_Q1.Width = $n_with - 35
    $Base_Map_Q1.left  = $Base_Game_Q1.left  = 10+($temp*4)

    $Name_Map_Q2.Width = $Name_Game_Q2.Width = $temp*4
    $Base_Map_Q2.Width = $Base_Game_Q2.Width = $temp*2
    $Disc_Map_Q2.Width = $Disc_Game_Q2.Width = $n_with - 35
    $Base_Map_Q2.left  = $Base_Game_Q2.left  = 10+($temp*4)

    $Name_Map_Q3.Width = $Name_Game_Q3.Width = $temp*4
    $Base_Map_Q3.Width = $Base_Game_Q3.Width = $temp*2
    $Disc_Map_Q3.Width = $Disc_Game_Q3.Width = $n_with - 35
    $Base_Map_Q3.left  = $Base_Game_Q3.left  = 10+($temp*4)

    $Pannel_Top.Width = $Panel_Map_O.Width = $Panel_Map_v.Width = $Panel_Game_O.Width = $Panel_Game_v.Width = $n_with - 33
    $Panel_Q1.Width = $Panel_Q2.Width = $Panel_Q3.Width = $n_with - 33
}
function add_map($select,$next){
    if($select -ne $null){
       $Last_Map.Enqueue($select)
       Switch ($select.g){
            'R'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\R\map_variants\$($select.File)" ".\haloreach\map_variants\$($select.File)" -Force
                }
            }
            '2'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\2\map_variants\$($select.File)" ".\groundhog\map_variants\$($lselect.File)" -Force
                }
            }
            '3'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\3\map_variants\$($select.File)" ".\halo3\map_variants\$($select.File)" -Force
                }
            }
            '4'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\4\map_variants\$($select.File)" ".\halo4\map_variants\$($select.File)" -Force
                }
            }
        }
    }
    if(($Last_Map.Count -gt $queue_size -or $next) -and $Last_Map.Count -ne 0){
        $last = $Last_Map.Dequeue()
        if($master_list_exist){
            Switch ($last.g){
                'R'{
                    Remove-Item -LiteralPath ".\haloreach\map_variants\$($last.file)"
                }
                '2'{
                    Remove-Item -LiteralPath ".\groundhog\map_variants\$($last.file)"
                }
                '3'{
                    Remove-Item -LiteralPath ".\halo3\map_variants\$($last.file)"
                }
                '4'{
                    Remove-Item -LiteralPath ".\halo4\map_variants\$($last.file)"
                }
            }
        }
    }

    $temp_list = $Last_Map.ToArray()
    
    $Name_Map_Q1.Text = $temp_list[0].Name
    $Base_Map_Q1.Text = $temp_list[0].Base
    $Disc_Map_Q1.Text = $temp_list[0].Discription
    
    $Name_Map_Q2.Text = $temp_list[1].Name
    $Base_Map_Q2.Text = $temp_list[1].Base
    $Disc_Map_Q2.Text = $temp_list[1].Discription
    
    $Name_Map_Q3.Text = $temp_list[2].Name
    $Base_Map_Q3.Text = $temp_list[2].Base
    $Disc_Map_Q3.Text = $temp_list[2].Discription
}
function add_game($select,$next){
    if($select -ne $null){
       $Last_Game.Enqueue($select)
       Switch ($select.g){
            'R'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\R\game_variants\$($select.File)" ".\haloreach\game_variants\$($select.File)" -Force
                }
            }
            '2'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\2\game_variants\$($select.File)" ".\groundhog\game_variants\$($lselect.File)" -Force
                }
            }
            '3'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\3\game_variants\$($select.File)" ".\halo3\game_variants\$($select.File)" -Force
                }
            }
            '4'{
                if($master_list_exist){
                    Copy-Item -LiteralPath "./Master_List\4\game_variants\$($select.File)" ".\halo4\game_variants\$($select.File)" -Force
                }
            }
        }
    }
    if(($Last_Game.Count -gt $queue_size -or $next) -and $Last_Game.Count -ne 0){
        $last = $Last_Game.Dequeue()
        if($master_list_exist){
            Switch ($last.g){
                'R'{
                    Remove-Item -LiteralPath ".\haloreach\game_variants\$($last.file)"
                }
                '2'{
                    Remove-Item -LiteralPath ".\groundhog\game_variants\$($last.file)"
                }
                '3'{
                    Remove-Item -LiteralPath ".\halo3\game_variants\$($last.file)"
                }
                '4'{
                    Remove-Item -LiteralPath ".\halo4\game_variants\$($last.file)"
                }
            }
        }
    }

    $temp_list = $Last_Game.ToArray()
    
    $Name_Game_Q1.Text = $temp_list[0].Name
    $Base_Game_Q1.Text = $temp_list[0].Base
    $Disc_Game_Q1.Text = $temp_list[0].Discription
    
    $Name_Game_Q2.Text = $temp_list[1].Name
    $Base_Game_Q2.Text = $temp_list[1].Base
    $Disc_Game_Q2.Text = $temp_list[1].Discription
    
    $Name_Game_Q3.Text = $temp_list[2].Name
    $Base_Game_Q3.Text = $temp_list[2].Base
    $Disc_Game_Q3.Text = $temp_list[2].Discription
}

function f_clear_map{
    $Text_Map.Text = ""
    if($maps_filtered.Count -ne $maps.count){
        $Combo_Map.Items.Clear()
        $Global:maps_filtered=$maps
        $Global:maps_filtered | %{$Combo_Map.Items.Add($_.Name)}
    }
    $Combo_Map.SelectedIndex=-1
    $Combo_Map.text = "Select a map or search above"
    f_select_map
}
function f_search_map{
    if($Text_Map.Text -eq ""){
        f_clear_map
    }else{
        $Combo_Map.Items.Clear()
        $Global:maps_filtered=$maps | ?{$_.Name.ToLower().contains($Text_Map.Text.ToLower()) -or $_.Discription.ToLower().contains($Text_Map.Text.ToLower())}
        $maps_filtered | %{$Combo_Map.Items.Add($_.Name)}
        $Combo_Map.SelectedIndex=-1
        $Combo_Map.text = "Select a map or search above"
    }f_select_map
}
function f_select_map{
    if($Combo_Map.SelectedIndex -eq -1){
        $Name_Map.Text = ""
        $Disc_Map.Text = ""
        $Base_Map.Text = ""
        $File_Map.Text = ""
        $Label3.text = ""
    }else{
        $map = $maps_filtered[$Combo_Map.SelectedIndex]
        $Name_Map.Text = $map.name
        $Disc_Map.Text = $map.Discription
        $Base_Map.Text = $map.Base
        $File_Map.Text = $map.File
        $Label3.text = "Map Base:"
    }
}
function f_random_map{
    $Combo_Map.SelectedIndex = Get-Random $Combo_Map.Items.Count
    f_select_map
}
function f_add_map{
    add_map $maps_filtered[$Combo_Map.SelectedIndex]

    $Combo_Map.SelectedIndex=-1
    $Combo_Map.text = "Select a map or search above"
    f_select_map
}
function f_clear_game{
    $Text_Game.Text = ""
    if($gamemodes_filtered.Count -ne $gamemodes.count){
        $Combo_Game.Items.Clear()
        $Global:gamemodes_filtered=$Global:gamemodes
        $Global:gamemodes_filtered | %{$Combo_Game.Items.Add($_.Name)}
    }
    $Combo_Game.SelectedIndex=-1
    $Combo_Game.text = "Select a gametype or search above"
    f_select_game
}
function f_search_game{
    if($Text_Game.Text -eq ""){
        f_clear_game
    }else{
        $Combo_Game.Items.Clear()
        $Global:gamemodes_filtered=$gamemodes | ?{$_.Name.ToLower().contains($Text_Game.Text.ToLower()) -or $_.Discription.ToLower().contains($Text_Game.Text.ToLower())}
        $gamemodes_filtered | %{$Combo_Game.Items.Add($_.Name)}
        $Combo_Game.SelectedIndex=-1
        $Combo_Game.text = "Select a gametype or search above"
    }f_select_game
}
function f_select_game{
    if($Combo_Game.SelectedIndex -eq -1){
        $Name_Game.Text = ""
        $Disc_game.Text = ""
        $Base_game.Text = ""
        $File_game.Text = ""
        $Label4.text = ""
    }else{
        $game = $gamemodes_filtered[$Combo_Game.SelectedIndex]
        $Name_Game.Text = $game.name
        $Disc_game.Text = $game.Discription
        $Base_game.Text = $game.Base
        $File_game.Text = $game.File
        $Label4.text = "Gametype group:"
    }
}
function f_random_game{
    $Combo_Game.SelectedIndex = Get-Random $Combo_Game.Items.Count
    f_select_game
}
function f_add_game{
    add_game $gamemodes_filtered[$Combo_Game.SelectedIndex]

    $Combo_Game.SelectedIndex=-1
    $Combo_Game.text = "Select a gametype or search above"
    f_select_game
}


#if($true){
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#<#    Main Bar

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(620,910)
$form.text                       = "MCC Map Selector"
$Form.minimumSize                = New-Object System.Drawing.Size(620,910)
#$form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#adadad")
$form.Add_Resize({ resize_form })

$Pannel_Top                          = New-Object system.Windows.Forms.Panel
$Pannel_Top.height                   = 32
$Pannel_Top.width                    = 602
$Pannel_Top.location                 = New-Object System.Drawing.Point(9,9)
$Pannel_Top.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")


$Change_Game                     = New-Object system.Windows.Forms.ComboBox
$Change_Game.width               = 150
$Change_Game.height              = 30
$Change_Game.Text                = "Select Game"
$Change_Game.location            = New-Object System.Drawing.Point(10,11)
$Change_Game.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',13)
$Change_Game.Items.Add("Halo Reach") | Out-Null
$Change_Game.Items.Add("Halo 2A") | Out-Null
$Change_Game.Items.Add("Halo 3") | Out-Null
$Change_Game.Items.Add("Halo 4") | Out-Null
$Change_Game.Add_TextChanged({ f_change_game })

$Move_Stuff                      = New-Object system.Windows.Forms.Button
$Move_Stuff.text                 = "Move Maps"
$Move_Stuff.width                = 150
$Move_Stuff.height               = 30
$Move_Stuff.location             = New-Object System.Drawing.Point(160,10)
$Move_Stuff.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Move_Stuff.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#292D2B")
$Move_Stuff.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Move_Stuff.FlatStyle            = [System.Windows.Forms.FlatStyle]::Flat
$Move_Stuff.Add_Click({ f_move_stuff })

$Next_Map                        = New-Object system.Windows.Forms.Button
$Next_Map.text                   = "Next Map"
$Next_Map.width                  = 150
$Next_Map.height                 = 30
$Next_Map.Visible                = $false
$Next_Map.location               = New-Object System.Drawing.Point(310,10)
$Next_Map.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Next_Map.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#292D2B")
$Next_Map.ForeColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Next_Map.FlatStyle              = [System.Windows.Forms.FlatStyle]::Flat
$Next_Map.Add_Click({ add_map $null $true })

$Next_Game                       = New-Object system.Windows.Forms.Button
$Next_Game.text                  = "Next Gamemode"
$Next_Game.width                 = 150
$Next_Game.height                = 30
$Next_Game.Visible               = $false
$Next_Game.location              = New-Object System.Drawing.Point(460,10)
$Next_Game.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Next_Game.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#292D2B")
$Next_Game.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Next_Game.FlatStyle             = [System.Windows.Forms.FlatStyle]::Flat
$Next_Game.Add_Click({ add_game $null $true })

$Menu_Bar = @($Change_Game,$Move_Stuff,$Next_Map,$Next_Game,$Pannel_Top)

#>#

#<#    Map Section

$Panel_Map_O                          = New-Object system.Windows.Forms.Panel
$Panel_Map_O.height                   = 72
$Panel_Map_O.width                    = 602
$Panel_Map_O.location                 = New-Object System.Drawing.Point(9,49)
$Panel_Map_O.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.AutoSize                 = $true
$Label1.width                    = 50
$Label1.height                   = 20
$Label1.location                 = New-Object System.Drawing.Point(10,50)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Clear_Map                       = New-Object system.Windows.Forms.Button
$Clear_Map.text                  = "X"
$Clear_Map.width                 = 50
$Clear_Map.height                = 50
$Clear_Map.location              = New-Object System.Drawing.Point(10,69)
$Clear_Map.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',16)
$Clear_Map.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")
$Clear_Map.FlatStyle             = [System.Windows.Forms.FlatStyle]::Flat
$Clear_Map.Add_Click({ f_clear_map })

$Text_Map                        = New-Object system.Windows.Forms.TextBox
$Text_Map.multiline              = $false
$Text_Map.width                  = 250
$Text_Map.height                 = 25
$Text_Map.location               = New-Object System.Drawing.Point(60,70)
$Text_Map.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Search_Map                      = New-Object system.Windows.Forms.Button
$Search_Map.text                 = "Search"
$Search_Map.width                = 100
$Search_Map.height               = 25
$Search_Map.location             = New-Object System.Drawing.Point(310,69)
$Search_Map.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Search_Map.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#5C9E05")
$Search_Map.FlatStyle            = [System.Windows.Forms.FlatStyle]::Flat
$Search_Map.Add_Click({ f_search_map })

$Combo_Map                       = New-Object system.Windows.Forms.ComboBox
$Combo_Map.text                  = "Select a map"
$Combo_Map.width                 = 350
$Combo_Map.height                = 25
$Combo_Map.location              = New-Object System.Drawing.Point(60,95)
$Combo_Map.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Combo_Map.Add_TextChanged({ f_select_map })

$Random_Map                      = New-Object system.Windows.Forms.Button
$Random_Map.text                 = "Random Map"
$Random_Map.width                = 100
$Random_Map.height               = 50
$Random_Map.location             = New-Object System.Drawing.Point(410,69)
$Random_Map.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Random_Map.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#1C7BD9")
$Random_Map.FlatStyle            = [System.Windows.Forms.FlatStyle]::Flat
$Random_Map.Add_Click({ f_random_map })

$Add_Map                         = New-Object system.Windows.Forms.Button
$Add_Map.text                    = "Add"
$Add_Map.width                   = 100
$Add_Map.height                  = 50
$Add_Map.location                = New-Object System.Drawing.Point(510,69)
$Add_Map.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Add_Map.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#1C7BD9")
$Add_Map.FlatStyle             = [System.Windows.Forms.FlatStyle]::Flat
$Add_Map.Add_Click({ f_add_map })

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

$Panel_Map_V                          = New-Object system.Windows.Forms.Panel
$Panel_Map_V.height                   = 82
$Panel_Map_V.width                    = 602
$Panel_Map_V.location                 = New-Object System.Drawing.Point(9,129)
$Panel_Map_V.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Map                        = New-Object system.Windows.Forms.Label
$Name_Map.text                   = ""
$Name_Map.AutoSize               = $true
$Name_Map.width                  = 600
$Name_Map.height                 = 20
$Name_Map.location               = New-Object System.Drawing.Point(10,130)
$Name_Map.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Map.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Map                        = New-Object system.Windows.Forms.Label
$Disc_Map.height                 = 40
$Disc_Map.width                  = 600
$Disc_Map.location               = New-Object System.Drawing.Point(10,150)
$Disc_Map.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.AutoSize                 = $true
$Label3.width                    = 50
$Label3.height                   = 20
$Label3.location                 = New-Object System.Drawing.Point(10,190)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Map                        = New-Object system.Windows.Forms.Label
$Base_Map.AutoSize               = $true
$Base_Map.width                  = 100
$Base_Map.height                 = 20
$Base_Map.location               = New-Object System.Drawing.Point(80,190)
$Base_Map.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Map.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$File_Map                        = New-Object system.Windows.Forms.Label
$File_Map.AutoSize               = $true
$File_Map.width                  = 100
$File_Map.height                 = 20
$File_Map.TextAlign              = 4
$File_Map.location               = New-Object System.Drawing.Point(410,190)
$File_Map.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$File_Map.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Map_Elements = @($Label1,$Clear_Map,$Text_Map,$Search_Map,$Combo_Map,$Random_Map,$Add_Map,$Name_Map,$Disc_Map,$Label3,$Base_Map,$File_Map,$Panel_Map_O,$Panel_Map_V)

#>#

#<#    Game Selection

$Panel_Game_O                          = New-Object system.Windows.Forms.Panel
$Panel_Game_O.height                   = 72
$Panel_Game_O.width                    = 602
$Panel_Game_O.location                 = New-Object System.Drawing.Point(9,219)
$Panel_Game_O.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Game Type"
$Label2.AutoSize                 = $true
$Label2.width                    = 50
$Label2.height                   = 20
$Label2.location                 = New-Object System.Drawing.Point(10,220)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Clear_Game                      = New-Object system.Windows.Forms.Button
$Clear_Game.text                 = "X"
$Clear_Game.width                = 50
$Clear_Game.height               = 50
$Clear_Game.location             = New-Object System.Drawing.Point(10,239)
$Clear_Game.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',16)
$Clear_Game.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")
$Clear_Game.FlatStyle            = [System.Windows.Forms.FlatStyle]::Flat
$Clear_Game.Add_Click({ f_clear_game })

$Text_Game                       = New-Object system.Windows.Forms.TextBox
$Text_Game.multiline             = $false
$Text_Game.width                 = 250
$Text_Game.height                = 20
$Text_Game.location              = New-Object System.Drawing.Point(60,240)
$Text_Game.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Search_Game                     = New-Object system.Windows.Forms.Button
$Search_Game.text                = "Search"
$Search_Game.width               = 100
$Search_Game.height              = 25
$Search_Game.location            = New-Object System.Drawing.Point(310,239)
$Search_Game.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Search_Game.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#5C9E05")
$Search_Game.FlatStyle           = [System.Windows.Forms.FlatStyle]::Flat
$Search_Game.Add_Click({ f_search_game })

$Combo_Game                      = New-Object system.Windows.Forms.ComboBox
$Combo_Game.text                 = "Select a gametype"
$Combo_Game.width                = 350
$Combo_Game.height               = 25
$Combo_Game.location             = New-Object System.Drawing.Point(60,265)
$Combo_Game.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Combo_Game.Add_TextChanged({ f_select_game })

$Random_Game                     = New-Object system.Windows.Forms.Button
$Random_Game.text                = "Random Gametype"
$Random_Game.width               = 100
$Random_Game.height              = 50
$Random_Game.location            = New-Object System.Drawing.Point(410,239)
$Random_Game.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Random_Game.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#1C7BD9")
$Random_Game.FlatStyle           = [System.Windows.Forms.FlatStyle]::Flat
$Random_Game.Add_Click({ f_random_game })

$Add_Game                        = New-Object system.Windows.Forms.Button
$Add_Game.text                   = "Add"
$Add_Game.width                  = 100
$Add_Game.height                 = 50
$Add_Game.location               = New-Object System.Drawing.Point(510,239)
$Add_Game.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Add_Game.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#1C7BD9")
$Add_Game.FlatStyle              = [System.Windows.Forms.FlatStyle]::Flat
$Add_Game.Add_Click({ f_add_game })

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

$Panel_Game_V                          = New-Object system.Windows.Forms.Panel
$Panel_Game_V.height                   = 82
$Panel_Game_V.width                    = 602
$Panel_Game_V.location                 = New-Object System.Drawing.Point(9,299)
$Panel_Game_V.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Game                       = New-Object system.Windows.Forms.Label
$Name_Game.AutoSize              = $true
$Name_Game.width                 = 600
$Name_Game.height                = 20
$Name_Game.location              = New-Object System.Drawing.Point(10,300)
$Name_Game.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Game.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Game                       = New-Object system.Windows.Forms.Label
$Disc_Game.height                = 40
$Disc_Game.width                 = 600
$Disc_Game.location              = New-Object System.Drawing.Point(10,320)
$Disc_Game.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.AutoSize                 = $true
$Label4.width                    = 50
$Label4.height                   = 20
$Label4.location                 = New-Object System.Drawing.Point(10,360)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label4.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Game                       = New-Object system.Windows.Forms.Label
$Base_Game.AutoSize              = $true
$Base_Game.width                 = 100
$Base_Game.height                = 20
$Base_Game.location              = New-Object System.Drawing.Point(120,360)
$Base_Game.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Game.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$File_Game                       = New-Object system.Windows.Forms.Label
$File_Game.AutoSize              = $true
$File_Game.width                 = 100
$File_Game.height                = 20
$File_Game.TextAlign             = 4
$File_Game.location              = New-Object System.Drawing.Point(410,360)
$File_Game.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$File_Game.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Game_Elements = @($Label2,$Clear_Game,$Text_Game,$Search_Game,$Combo_Game,$Random_Game,$Add_Game,$Name_Game,$Disc_Game,$Label4,$Base_Game,$File_Game,$Panel_Game_O,$Panel_Game_V)

#>#

#<#    Queueue Selection

$Panel_Q1                          = New-Object system.Windows.Forms.Panel
$Panel_Q1.height                   = 122
$Panel_Q1.width                    = 602
$Panel_Q1.location                 = New-Object System.Drawing.Point(9,419)
$Panel_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Map_Q1                          = New-Object system.Windows.Forms.Label
$Name_Map_Q1.AutoSize                 = $true
$Name_Map_Q1.width                    = 400
$Name_Map_Q1.height                   = 20
$Name_Map_Q1.location                 = New-Object System.Drawing.Point(10,420)
$Name_Map_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Map_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Map_Q1                          = New-Object system.Windows.Forms.Label
$Base_Map_Q1.AutoSize                 = $true
$Base_Map_Q1.width                    = 200
$Base_Map_Q1.height                   = 20
$Base_Map_Q1.TextAlign                = 4
$Base_Map_Q1.location                 = New-Object System.Drawing.Point(410,420)
$Base_Map_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Map_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Map_Q1                          = New-Object system.Windows.Forms.Label
$Disc_Map_Q1.AutoSize                 = $true
$Disc_Map_Q1.width                    = 600
$Disc_Map_Q1.height                   = 40
$Disc_Map_Q1.location                 = New-Object System.Drawing.Point(10,440)
$Disc_Map_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Map_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Game_Q1                          = New-Object system.Windows.Forms.Label
$Name_Game_Q1.AutoSize                 = $true
$Name_Game_Q1.width                    = 400
$Name_Game_Q1.height                   = 20
$Name_Game_Q1.location                 = New-Object System.Drawing.Point(10,480)
$Name_Game_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Game_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Game_Q1                          = New-Object system.Windows.Forms.Label
$Base_Game_Q1.AutoSize                 = $true
$Base_Game_Q1.width                    = 200
$Base_Game_Q1.height                   = 20
$Base_Game_Q1.TextAlign                = 4
$Base_Game_Q1.location                 = New-Object System.Drawing.Point(410,480)
$Base_Game_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Game_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Game_Q1                          = New-Object system.Windows.Forms.Label
$Disc_Game_Q1.AutoSize                 = $true
$Disc_Game_Q1.width                    = 600
$Disc_Game_Q1.height                   = 40
$Disc_Game_Q1.location                 = New-Object System.Drawing.Point(10,500)
$Disc_Game_Q1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Game_Q1.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$qu_1 = @($Name_Map_Q1,$Base_Map_Q1,$Disc_Map_Q1,$Name_Game_Q1,$Base_Game_Q1,$Disc_Game_Q1,$Panel_Q1)

$Panel_Q2                          = New-Object system.Windows.Forms.Panel
$Panel_Q2.height                   = 122
$Panel_Q2.width                    = 602
$Panel_Q2.location                 = New-Object System.Drawing.Point(9,579)
$Panel_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Map_Q2                          = New-Object system.Windows.Forms.Label
$Name_Map_Q2.AutoSize                 = $true
$Name_Map_Q2.width                    = 400
$Name_Map_Q2.height                   = 20
$Name_Map_Q2.location                 = New-Object System.Drawing.Point(10,580)
$Name_Map_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Map_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Map_Q2                          = New-Object system.Windows.Forms.Label
$Base_Map_Q2.AutoSize                 = $true
$Base_Map_Q2.width                    = 200
$Base_Map_Q2.height                   = 20
$Base_Map_Q2.TextAlign                = 4
$Base_Map_Q2.location                 = New-Object System.Drawing.Point(410,580)
$Base_Map_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Map_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Map_Q2                          = New-Object system.Windows.Forms.Label
$Disc_Map_Q2.AutoSize                 = $true
$Disc_Map_Q2.width                    = 600
$Disc_Map_Q2.height                   = 40
$Disc_Map_Q2.location                 = New-Object System.Drawing.Point(10,600)
$Disc_Map_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Map_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Game_Q2                          = New-Object system.Windows.Forms.Label
$Name_Game_Q2.AutoSize                 = $true
$Name_Game_Q2.width                    = 400
$Name_Game_Q2.height                   = 20
$Name_Game_Q2.location                 = New-Object System.Drawing.Point(10,640)
$Name_Game_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Game_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Game_Q2                          = New-Object system.Windows.Forms.Label
$Base_Game_Q2.AutoSize                 = $true
$Base_Game_Q2.width                    = 200
$Base_Game_Q2.height                   = 20
$Base_Game_Q2.TextAlign                = 4
$Base_Game_Q2.location                 = New-Object System.Drawing.Point(410,640)
$Base_Game_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Game_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Game_Q2                          = New-Object system.Windows.Forms.Label
$Disc_Game_Q2.AutoSize                 = $true
$Disc_Game_Q2.width                    = 600
$Disc_Game_Q2.height                   = 40
$Disc_Game_Q2.location                 = New-Object System.Drawing.Point(10,660)
$Disc_Game_Q2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Game_Q2.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$qu_2 = @($Name_Map_Q2,$Base_Map_Q2,$Disc_Map_Q2,$Name_Game_Q2,$Base_Game_Q2,$Disc_Game_Q2,$Panel_Q2)

$Panel_Q3                          = New-Object system.Windows.Forms.Panel
$Panel_Q3.height                   = 122
$Panel_Q3.width                    = 602
$Panel_Q3.location                 = New-Object System.Drawing.Point(9,739)
$Panel_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Map_Q3                          = New-Object system.Windows.Forms.Label
$Name_Map_Q3.AutoSize                 = $true
$Name_Map_Q3.width                    = 400
$Name_Map_Q3.height                   = 20
$Name_Map_Q3.location                 = New-Object System.Drawing.Point(10,740)
$Name_Map_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Map_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Map_Q3                          = New-Object system.Windows.Forms.Label
$Base_Map_Q3.AutoSize                 = $true
$Base_Map_Q3.width                    = 200
$Base_Map_Q3.height                   = 20
$Base_Map_Q3.TextAlign                = 4
$Base_Map_Q3.location                 = New-Object System.Drawing.Point(410,740)
$Base_Map_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Map_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Map_Q3                          = New-Object system.Windows.Forms.Label
$Disc_Map_Q3.AutoSize                 = $true
$Disc_Map_Q3.width                    = 600
$Disc_Map_Q3.height                   = 40
$Disc_Map_Q3.location                 = New-Object System.Drawing.Point(10,760)
$Disc_Map_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Map_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Name_Game_Q3                          = New-Object system.Windows.Forms.Label
$Name_Game_Q3.AutoSize                 = $true
$Name_Game_Q3.width                    = 400
$Name_Game_Q3.height                   = 20
$Name_Game_Q3.location                 = New-Object System.Drawing.Point(10,800)
$Name_Game_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Name_Game_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Base_Game_Q3                          = New-Object system.Windows.Forms.Label
$Base_Game_Q3.AutoSize                 = $true
$Base_Game_Q3.width                    = 200
$Base_Game_Q3.height                   = 20
$Base_Game_Q3.TextAlign                = 4
$Base_Game_Q3.location                 = New-Object System.Drawing.Point(410,800)
$Base_Game_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Base_Game_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Disc_Game_Q3                          = New-Object system.Windows.Forms.Label
$Disc_Game_Q3.AutoSize                 = $true
$Disc_Game_Q3.width                    = 600
$Disc_Game_Q3.height                   = 40
$Disc_Game_Q3.location                 = New-Object System.Drawing.Point(10,820)
$Disc_Game_Q3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Disc_Game_Q3.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$qu_3 = @($Name_Map_Q3,$Base_Map_Q3,$Disc_Map_Q3,$Name_Game_Q3,$Base_Game_Q3,$Disc_Game_Q3,$Panel_Q3)

#>#

#}

# variables
$global:Last_Map = New-Object System.Collections.Queue
$global:Last_Game = New-Object System.Collections.Queue
$global:queue_size = 3
$global:ret = $null
$Global:maps = @()
$Global:maps_filtered = @()
$Global:gamemodes = @()
$Global:gamemodes_filtered = @()

$global:master_list_exist = Test-Path ./Master_List -ErrorAction SilentlyContinue


$Map_Elements | %{$_.visible = $false}
$Game_Elements | %{$_.visible = $false}
$qu_1 | %{$_.visible = $false}
$qu_2 | %{$_.visible = $false}
$qu_3 | %{$_.visible = $false}

$Form.controls.AddRange($Menu_Bar+$Map_Elements+$Game_Elements+$qu_1+$qu_2+$qu_3)
$result = $form.ShowDialog()
$Form.Dispose()
