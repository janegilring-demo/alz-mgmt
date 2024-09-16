New-AzSubscriptionDeployment -Location "norwayeast" -Name ("caf-deployment-identity-ad" -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])) -TemplateFile "../ad/main.bicep" -WhatIf:$false

