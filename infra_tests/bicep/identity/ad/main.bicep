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
//param keyVaultName string
param virtualNetworkName string
param virtualNetworkAddressSpace string
param virtualNetworkLocation string
param virtualNetworkResourceGroupName string
param virtualWanHubResourceGroupName string
param virtualWanHubSubscriptionId string
param virtualWanHubName string
param virtualNetworkVwanEnableInternetSecurity bool
param virtualWanHubConnectionName string
param virtualWanHubConnectionAssociatedRouteTable string
param virtualWanHubConnectionPropogatedRouteTables array
param virtualWanHubConnectionPropogatedLabels array
param vHubRoutingIntentEnabled bool
param subscriptionId string

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
    virtualNetworkPeeringEnabled: false // set to false until the AVM module supports vWAN hub connections
    hubVirtualNetworkResourceId: hubVirtualNetworkResourceId
    location: location
    tags: tags
  }
}

module createLzVirtualWanConnection 'hubVirtualNetworkConnections.bicep' = if (virtualNetworkPeeringEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName) && !empty(virtualWanHubResourceGroupName) && !empty(virtualWanHubSubscriptionId)) {
  dependsOn: [
    network
  ]
  scope: resourceGroup(virtualWanHubSubscriptionId, virtualWanHubResourceGroupName)
  name: 'ad-network-hub-peering-deployment'
  params: {
    name: virtualWanHubConnectionName
    virtualHubName: virtualWanHubName
    remoteVirtualNetworkId: '/subscriptions/${subscriptionId}/resourceGroups/${virtualNetworkResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${virtualNetworkName}'
    enableInternetSecurity: virtualNetworkVwanEnableInternetSecurity
    routingConfiguration: !vHubRoutingIntentEnabled
      ? {
          associatedRouteTable: {
            id: virtualWanHubConnectionAssociatedRouteTable
          }
          propagatedRouteTables: {
            ids: virtualWanHubConnectionPropogatedRouteTables
            labels: virtualWanHubConnectionPropogatedLabels
          }
        }
      : {}
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
