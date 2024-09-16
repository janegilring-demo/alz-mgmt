targetScope = 'subscription'

@description('Optional. The location to deploy resources to.')
param location string = 'norwayeast'

@description('Required Tags')
param tags object = {
  serviceowner: 'Infrastructure Services'
  service: 'Domain Controller'
  costcenter: '60132'
  environment: 'production'
}

param virtualNetworkPeeringEnabled bool
param hubVirtualNetworkResourceId string
param keyVaultName string

resource ADResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-ad'
  location: location
  tags: tags
}

// module RGArcPrdNoe1 'br/public:avm/res/resources/resource-group:0.4.0' = {
//   name: 'rg-arc-prd-noe-1-deploy'
//   params: {
//     name: 'rg-arc-prd-noe-1'
//     location: 'norwayeast'
//   }
// }

module network 'network.bicep' = {
  name: 'ad-network-deployment'
  scope: ADResourceGroup
  params: {
    virtualNetworkPeeringEnabled: virtualNetworkPeeringEnabled
    hubVirtualNetworkResourceId: hubVirtualNetworkResourceId
    location: location
    tags: tags
  }
}

// module vm 'vm.bicep' = {
//   name: 'vm-domain-controllers-deployment'
//   scope: ADResourceGroup
//   params: {
//     location: location
//     tags: tags
//     keyVaultName: keyVaultName
//   }
// }

//module bastion 'bastion.bicep' = {
//  name: 'bastion'
//  scope: workloadResourceGroup
//  params: {
//    location: location
//    workload: workload
//  }
//}
