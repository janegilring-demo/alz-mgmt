param (
  [Parameter()]
  [String]$Location = 'norwayeast',

  [Parameter()]
  [String]$TemplateFile = './ad/main.bicep',

  [Parameter()]
  [String]$TemplateParameterFile = './ad/main.bicepparam',

  [Parameter()]
  [Boolean]$WhatIfEnabled = [System.Convert]::ToBoolean($($env:IS_PULL_REQUEST))
)

Write-Verbose "Is WhatIfEnabled: $($WhatIfEnabled)"
Write-Host "Is WhatIfEnabled: $($WhatIfEnabled)"

$name = 'lz-vending-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
if($WhatIfEnabled)
{
  New-AzSubscriptionDeployment -Name $name -TemplateParameterFile $TemplateParameterFile -TemplateFile $TemplateFile -Location $Location -Verbose:$true -WhatIf:$true

}else{
  New-AzSubscriptionDeploymentStack -Name $name -TemplateParameterFile $TemplateParameterFile -TemplateFile $TemplateFile -Location $Location -DenySettingsMode "none" -Verbose:$true -ActionOnUnmanage DeleteResources
}