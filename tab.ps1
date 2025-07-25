# sets the terminal tab color and title 
# Eg.
#  tab.ps1 hello        # sets title and colour to random value
#  tab.ps1              # changes color randomly
#  tab.ps1 fixed 10     # sets title to "fixed" and color to fixed value
#  tab.ps1 new -newtab  # opens a new tab with title "new" and random colour

[CmdletBinding()]
param(

    [Parameter(Mandatory = $false, Position = 0, HelpMessage = "title")]
    [string] $title,
    [Parameter(Mandatory = $false, Position = 1, HelpMessage = "colour as rrggbb or 0 to keep")]
    [string] $color = "",
    [Parameter(HelpMessage = "open in new tab")]
    [switch] $newTab,
    [Parameter(HelpMessage = "only colour the header")]
    [switch] $headerOnly,
    [Parameter(HelpMessage = "shows the color that has been set")]
    [switch] $showColor,
    [Parameter(HelpMessage = "switch to directory")]
    [string] $directory
)



#define relative brightness of header and background

$tabMagnitude = 13
$backgroundMagnitude = 4
$changeColor = $true

if ($color -ne "") {
    if ($color.Length -ne 6) {
        $changeColor = $false
    }
    else {
        
        $red = [convert]::ToInt32($color.Substring(0, 2), 16)
        $green = [convert]::ToInt32($color.Substring(2, 2), 16)
        $blue = [convert]::ToInt32($color.Substring(4, 2), 16)
    }
}
else {
   
    $red = get-random -maximum 0xff
    $green = get-random -maximum 0xff
    $blue = get-random -maximum 0xff
}


function str($r, $g, $b,$format) {
    $rx = $format -f [int]$r
    $gx = $format -f [int]$g
    $bx = $format -f [int]$b
    $r = "rgb:$rx/$gx/$bx"
    return $r
}

# todo fix this up with some simple algebra and use
# magnitude rather than dominant axis
function scale($r, $g, $b, $limit) {
    while (($r -gt $limit) -or ($g -gt $limit) -or ($b -gt $limit)) {
        $r = $r * 0.9
        $g = $g * 0.9
        $b = $b * 0.9
    }
    return str $r $g  $b '{0:x}'
}


function setTabColor($r, $g, $b) {
    
    $tabColor = scale $red $green $blue $tabMagnitude
    write-host "`e]4;264;$tabColor`a"
}
function setBackgroundColor($r, $g, $b) {
    $bgColor = scale $red $green $blue $backgroundMagnitude
    write-host "`e]4;262;$bgColor`a"
}
    

    
if ($newTab) {


    if ($directory -ne "") {
        wt -w 0  new-tab  --title $title  -p "PowerShell"   pwsh -noexit -c "tab -directory $directory"
    }
    else {
        wt -w 0  new-tab  --title $title  -p "PowerShell"   pwsh -noexit -c tab
    }
}
else {
   
    if ($title -ne "") {

        if (Test-Path variable:psISE) {
            $psISE.CurrentPowerShellTab.DisplayName = $title
        }
        else {
            $host.UI.RawUI.WindowTitle = $title
        }
    }
    if ($changeColor) {
        setTabColor $red $green $blue
        if (-not $headerOnly) {
            setBackgroundColor $red $green $blue
        }
        if ($showColor) {
            $rgb = (str $red $green $blue '{0:x2}').Replace("/", "").Replace("rgb:", "")
            write-host "base color: $rgb"
        }
    }
    if ($directory -ne "") {
        Set-Location $directory
    }
}

