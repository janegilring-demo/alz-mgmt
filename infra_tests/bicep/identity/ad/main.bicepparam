using 'main.bicep' /*TODO: Provide a path to a bicep template*/

param location = 'norwayeast'
param virtualNetworkPeeringEnabled = false
param hubVirtualNetworkResourceId = '/subscriptions/4cb2be95-bb60-4223-8362-ec257c18f906/resourceGroups/rg-alz-connectivity/providers/Microsoft.Network/virtualHubs/alz-vhub-norwayeast'
//param keyVaultName = 'kv-ad'
param virtualNetworkName = 'vnet-ad'
param virtualNetworkAddressSpace = '10.48.12.0/24'
param virtualNetworkLocation = 'norwayeast'
param virtualNetworkResourceGroupName = 'rg-ad'
param virtualWanHubResourceGroupName = 'rg-alz-connectivity'
param virtualWanHubSubscriptionId = '4cb2be95-bb60-4223-8362-ec257c18f906'
param virtualWanHubName = 'alz-vhub-norwayeast'
param virtualNetworkVwanEnableInternetSecurity = true
param virtualWanHubConnectionName = 'vnet-ad-to-hub-norwayeast'
param virtualWanHubConnectionAssociatedRouteTable = ''
param virtualWanHubConnectionPropogatedRouteTables  = []//array
param virtualWanHubConnectionPropogatedLabels  = []//array
param vHubRoutingIntentEnabled = true
param subscriptionId = 'd21798f8-eb17-4387-b164-a7168d77881c' // Identity

param tags = {
  serviceowner: 'Infrastructure Team'
  costcenter: '12345'
  environment: 'production'
}
