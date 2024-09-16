@description('Optional. The location to deploy resources to.')
param location string = 'norwayeast'

@description('Required Tags')
param tags object = {
  serviceowner: 'Infrastructure Services'
  service: 'Domain Controller'
  costcenter: '60132'
  environment: 'production'
}
@description('Variables')
param adminUsername string = 'azureadmin'
param hostname string = 'vm-dc-ne-00'
param keyVaultName string = 'kv-prd-noe-ad'

@secure()
param vmsecret string = newGuid()

resource snetdc 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  scope: resourceGroup('rg-ad')
  name: 'vnet-ad/snet-domaincontrollers'
}

module vault 'br/public:avm/res/key-vault/vault:0.8.0' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: '${keyVaultName}-${uniqueString(deployment().name)}'
    // Non-required parameters
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    enableTelemetry: true
    location: 'norwayeast'
    secrets: [
      {
        name: 'vm-01-password'
        value: vmsecret
      }
    ]
  }
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.6.0' = [
  for i in range(0, 2): {
    name: 'virtualMachineDeployment-0${(i+1)}'
    params: {
      // Required parameters
      adminUsername: adminUsername
      zone: (i + 1)
      encryptionAtHost: false
      allowExtensionOperations: true
      enableAutomaticUpdates: true
      imageReference: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: '2022-datacenter-azure-edition-hotpatch'
        version: 'latest'
      }
      name: '${hostname}${(i+1)}'
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig01'
              subnetResourceId: snetdc.id
            }
          ]
          nicSuffix: '-nic-01'
        }
      ]
      osDisk: {
        caching: 'ReadWrite'
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      dataDisks: [
        {
          name: '${hostname}${(i+1)}-disk-data-01'
          caching: 'None'
          diskSizeGB: 64
          lun: 0
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      ]

      osType: 'Windows'
      vmSize: 'Standard_D2ads_v5'
      // Non-required parameters
      adminPassword: vmsecret
      location: location
      tags: tags
    }
    dependsOn: [
      snetdc
    ]
  }
]

resource vmdcext 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = [
  for i in range(0, 2): {
    name: 'vm-dc-ne-00${(i + 1)}/DC'
    location: location
    properties: {
      autoUpgradeMinorVersion: true
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.4'
      settings: {
        commandToExecute: 'powershell Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools'
      }
    }
    dependsOn: [
      virtualMachine
    ]
  }
]
