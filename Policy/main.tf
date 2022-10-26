# terraform workspace new Policy

# Configure the Azure provider
terraform {
  required_version = ">=0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88"
    }
  }
  backend "azurerm" {
    subscription_id      = "2aaaea6f-6f28-45c4-bbb3-f966dc631556"
    resource_group_name  = "Azure-Terraform"
    storage_account_name = "arsazureterraform"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }               
}
provider "azurerm" {
    features {}
}
#===================================
# variables
#===================================

locals{
  location = "centralus"
  logAnalyticsWorkspaceId = "5be7f2fc-05b0-48db-ba46-d1abbd847b72"
}

#===================================
# variables
#===================================


variable "VmSKU_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow VM SKU limitations"
}

# to get managment group id's az account management-group list
variable "Vm_PublicIP_exception"{
  type    = list(string)
  default = ["/providers/Microsoft.Management/managementGroups/Public", "/providers/Microsoft.Management/managementGroups/Sandbox"]
  description = "scopes that are not required to follow No public ip limitations"
}

variable allowedlocations{
  type    = list(string)
  default = ["centralus"] #uscentral
  description = "List of allowed locations"
}
variable "location_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow location limitations"
}

variable "sa_publicaccess_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow Public Storage account limitations"
}

variable "AllowedResourceTypes"{
  type    = list(string)
  default = ["microsoft.insights/actiongroups", "microsoft.insights/activitylogalerts", "microsoft.insights/alertrules", "microsoft.insights/autoscalesettings", "microsoft.insights/components", "microsoft.insights/components/aggregate", "microsoft.insights/components/analyticsitems", "microsoft.insights/components/annotations", "microsoft.insights/components/api", "microsoft.insights/components/apikeys", "microsoft.insights/components/currentbillingfeatures", "microsoft.insights/components/defaultworkitemconfig", "microsoft.insights/components/events", "microsoft.insights/components/exportconfiguration", "microsoft.insights/components/extendqueries", "microsoft.insights/components/favorites", "microsoft.insights/components/featurecapabilities", "microsoft.insights/components/generatediagnosticservicereadonlytoken", "microsoft.insights/components/generatediagnosticservicereadwritetoken", "microsoft.insights/components/getavailablebillingfeatures", "microsoft.insights/components/linkedstorageaccounts", "microsoft.insights/components/metadata", "microsoft.insights/components/metricdefinitions", "microsoft.insights/components/metrics", "microsoft.insights/components/move", "microsoft.insights/components/myfavorites", "microsoft.insights/components/myanalyticsitems", "microsoft.insights/components/operations", "microsoft.insights/components/pricingplans", "microsoft.insights/components/proactivedetectionconfigs", "microsoft.insights/components/purge", "microsoft.insights/components/query", "microsoft.insights/components/syntheticmonitorlocations", "microsoft.insights/components/webtests", "microsoft.insights/components/quotastatus", "microsoft.insights/components/workitemconfigs", "microsoft.insights/createnotifications", "microsoft.insights/datacollectionendpoints", "microsoft.insights/datacollectionendpoints/networksecurityperimeterassociationproxies", "microsoft.insights/datacollectionruleassociations", "microsoft.insights/datacollectionendpoints/networksecurityperimeterconfigurations", "microsoft.insights/datacollectionendpoints/scopedprivatelinkproxies", "microsoft.insights/diagnosticsettings", "microsoft.insights/datacollectionrules", "microsoft.insights/diagnosticsettingscategories", "microsoft.insights/eventcategories", "microsoft.insights/eventtypes", "microsoft.insights/extendeddiagnosticsettings", "microsoft.insights/generatediagnosticservicereadonlytoken", "microsoft.insights/generatediagnosticservicereadwritetoken", "microsoft.insights/generatelivetoken", "microsoft.insights/guestdiagnosticsettings", "microsoft.insights/guestdiagnosticsettingsassociation", "microsoft.insights/listmigrationdate", "microsoft.insights/locations", "microsoft.insights/locations/notifynetworksecurityperimeterupdatesavailable", "microsoft.insights/locations/operationresults", "microsoft.insights/logdefinitions", "microsoft.insights/logprofiles", "microsoft.insights/logs", "microsoft.insights/metricalerts", "microsoft.insights/metricbaselines", "microsoft.insights/metricbatch", "microsoft.insights/metrics", "microsoft.insights/migratealertrules", "microsoft.insights/metricnamespaces", "microsoft.insights/metricdefinitions", "microsoft.insights/migratetonewpricingmodel", "microsoft.insights/monitoredobjects", "microsoft.insights/myworkbooks", "microsoft.insights/notificationgroups", "microsoft.insights/notificationstatus", "microsoft.insights/operations", "microsoft.insights/privatelinkscopeoperationstatuses", "microsoft.insights/privatelinkscopes", "microsoft.insights/privatelinkscopes/privateendpointconnectionproxies", "microsoft.insights/privatelinkscopes/privateendpointconnections", "microsoft.insights/privatelinkscopes/scopedresources", "microsoft.insights/rollbacktolegacypricingmodel", "microsoft.insights/scheduledqueryrules", "microsoft.insights/topology", "microsoft.insights/transactions", "microsoft.insights/vminsightsonboardingstatuses", "microsoft.insights/webtests", "microsoft.insights/webtests/gettestresultfile", "microsoft.insights/workbooks", "microsoft.insights/workbooktemplates", "microsoft.keyvault/checkmhsmnameavailability", "microsoft.keyvault/checknameavailability", "microsoft.keyvault/deletedmanagedhsms", "microsoft.keyvault/deletedvaults", "microsoft.keyvault/hsmpools", "microsoft.keyvault/locations", "microsoft.keyvault/locations/deletedmanagedhsms", "microsoft.keyvault/locations/deletedvaults", "microsoft.keyvault/locations/deletevirtualnetworkorsubnets", "microsoft.keyvault/locations/managedhsmoperationresults", "microsoft.keyvault/locations/notifynetworksecurityperimeterupdatesavailable", "microsoft.keyvault/locations/operationresults", "microsoft.keyvault/managedhsms", "microsoft.keyvault/managedhsms/privateendpointconnections", "microsoft.keyvault/operations", "microsoft.keyvault/vaults", "microsoft.keyvault/vaults/accesspolicies", "microsoft.keyvault/vaults/keys", "microsoft.keyvault/vaults/eventgridfilters", "microsoft.keyvault/vaults/keys/versions", "microsoft.keyvault/vaults/privateendpointconnections", "microsoft.keyvault/vaults/secrets", "microsoft.maintenance/applyupdates", "microsoft.maintenance/configurationassignments", "microsoft.maintenance/maintenanceconfigurations", "microsoft.maintenance/operations", "microsoft.maintenance/publicmaintenanceconfigurations", "microsoft.maintenance/updates", "microsoft.managedidentity/identities", "microsoft.managedidentity/operations", "microsoft.managedidentity/userassignedidentities", "microsoft.managedidentity/userassignedidentities/federatedidentitycredentials", "microsoft.managedservices/marketplaceregistrationdefinitions", "microsoft.managedservices/operations", "microsoft.managedservices/registrationassignments", "microsoft.managedservices/operationstatuses", "microsoft.managedservices/registrationdefinitions", "microsoft.management/checknameavailability", "microsoft.management/getentities", "microsoft.management/managementgroups/settings", "microsoft.management/managementgroups", "microsoft.management/operationresults", "microsoft.management/operationresults/asyncoperation", "microsoft.management/operations", "microsoft.management/resources", "microsoft.management/starttenantbackfill", "microsoft.management/tenantbackfillstatus", "microsoft.marketplace/listavailableoffers", "microsoft.marketplace/macc", "microsoft.marketplace/offers", "microsoft.marketplace/offertypes", "microsoft.marketplace/offertypes/publishers", "microsoft.marketplace/offertypes/publishers/offers", "microsoft.marketplace/offertypes/publishers/offers/plans", "microsoft.marketplace/offertypes/publishers/offers/plans/agreements", "microsoft.marketplace/offertypes/publishers/offers/plans/configs/importimage", "microsoft.marketplace/operations", "microsoft.marketplace/offertypes/publishers/offers/plans/configs", "microsoft.marketplace/privategalleryitems", "microsoft.marketplace/privatestores", "microsoft.marketplace/privatestores/adminrequestapprovals", "microsoft.marketplace/privatestoreclient", "microsoft.marketplace/privatestores/anyexistingoffersinthecollections", "microsoft.marketplace/privatestores/billingaccounts", "microsoft.marketplace/privatestores/bulkcollectionsaction", "microsoft.marketplace/privatestores/collections", "microsoft.marketplace/privatestores/collections/approveallitems", "microsoft.marketplace/privatestores/collections/disableapproveallitems", "microsoft.marketplace/privatestores/collections/offers", "microsoft.marketplace/privatestores/collections/offers/upsertofferwithmulticontext", "microsoft.marketplace/privatestores/collections/transferoffers", "microsoft.marketplace/privatestores/collectionstosubscriptionsmapping", "microsoft.marketplace/privatestores/fetchallsubscriptionsintenant", "microsoft.marketplace/privatestores/listnewplansnotifications", "microsoft.marketplace/privatestores/liststopselloffersplansnotifications", "microsoft.marketplace/privatestores/listsubscriptionscontext", "microsoft.marketplace/privatestores/offers", "microsoft.marketplace/privatestores/offers/acknowledgenotification", "microsoft.marketplace/privatestores/queryapprovedplans", "microsoft.marketplace/privatestores/querynotificationsstate", "microsoft.marketplace/privatestores/queryoffers", "microsoft.marketplace/privatestores/queryuseroffers", "microsoft.marketplace/privatestores/requestapprovals", "microsoft.marketplace/privatestores/requestapprovals/query", "microsoft.marketplace/privatestores/requestapprovals/withdrawplan", "microsoft.marketplace/products", "microsoft.marketplace/publishers", "microsoft.marketplace/publishers/offers", "microsoft.marketplace/publishers/offers/amendments", "microsoft.marketplace/register", "microsoft.marketplace/search", "microsoft.marketplaceordering/agreements", "microsoft.marketplaceordering/offertypes", "microsoft.marketplacenotifications/reviewsnotifications", "microsoft.marketplacenotifications/operations", "microsoft.monitor/accounts", "microsoft.monitor/operations", "microsoft.network/applicationgatewayavailablerequestheaders", "microsoft.network/applicationgatewayavailableresponseheaders", "microsoft.network/applicationgatewayavailableservervariables", "microsoft.network/applicationgatewayavailablessloptions", "microsoft.network/applicationgateways", "microsoft.network/applicationgatewayavailablewafrulesets", "microsoft.network/applicationgateways/privateendpointconnections", "microsoft.network/applicationsecuritygroups", "microsoft.network/applicationgatewaywebapplicationfirewallpolicies", "microsoft.network/azurefirewallfqdntags", "microsoft.network/azurefirewalls", "microsoft.network/azurewebcategories", "microsoft.network/bastionhosts", "microsoft.network/bgpservicecommunities", "microsoft.network/checkfrontdoornameavailability", "microsoft.network/checktrafficmanagernameavailability", "microsoft.network/cloudserviceslots", "microsoft.network/connections", "microsoft.network/customipprefixes", "microsoft.network/ddoscustompolicies", "microsoft.network/ddosprotectionplans", "microsoft.network/dnsforwardingrulesets", "microsoft.network/dnsforwardingrulesets/forwardingrules", "microsoft.network/dnsforwardingrulesets/virtualnetworklinks", "microsoft.network/dnsoperationresults", "microsoft.network/dnsoperationstatuses", "microsoft.network/dnsresolvers", "microsoft.network/dnszones", "microsoft.network/dnszones/a", "microsoft.network/dnsresolvers/outboundendpoints", "microsoft.network/dnsresolvers/inboundendpoints", "microsoft.network/dnszones/aaaa", "microsoft.network/dnszones/all", "microsoft.network/dnszones/caa", "microsoft.network/dnszones/cname", "microsoft.network/dnszones/mx", "microsoft.network/dnszones/ns", "microsoft.network/dnszones/ptr", "microsoft.network/dnszones/recordsets", "microsoft.network/dnszones/soa", "microsoft.network/dnszones/srv", "microsoft.network/dnszones/txt", "microsoft.network/dscpconfigurations", "microsoft.network/expressroutecircuits", "microsoft.network/expressroutecircuits/authorizations", "microsoft.network/expressroutecircuits/peerings", "microsoft.network/expressroutecircuits/peerings/connections", "microsoft.network/expressroutecrossconnections", "microsoft.network/expressroutecrossconnections/peerings", "microsoft.network/expressroutegateways", "microsoft.network/expressroutegateways/expressrouteconnections", "microsoft.network/expressrouteports", "microsoft.network/expressrouteportslocations", "microsoft.network/expressrouteproviderports", "microsoft.network/expressrouteserviceproviders", "microsoft.network/firewallpolicies", "microsoft.network/firewallpolicies/rulecollectiongroups", "microsoft.network/firewallpolicies/rulegroups", "microsoft.network/frontdooroperationresults", "microsoft.network/frontdoors", "microsoft.network/frontdoors/backendpools", "microsoft.network/frontdoors/frontendendpoints", "microsoft.network/frontdoors/frontendendpoints/customhttpsconfiguration", "microsoft.network/frontdoors/rulesengines", "microsoft.network/frontdoorwebapplicationfirewallmanagedrulesets", "microsoft.network/frontdoorwebapplicationfirewallpolicies", "microsoft.network/getdnsresourcereference", "microsoft.network/internalnotify", "microsoft.network/internalpublicipaddresses", "microsoft.network/ipallocations", "microsoft.network/ipgroups", "microsoft.network/loadbalancers", "microsoft.network/loadbalancers/backendaddresspools", "microsoft.network/loadbalancers/inboundnatrules", "microsoft.network/localnetworkgateways", "microsoft.network/locations/applicationgatewaywafdynamicmanifest", "microsoft.network/locations", "microsoft.network/locations/autoapprovedprivatelinkservices", "microsoft.network/locations/availabledelegations", "microsoft.network/locations/availableservicealiases", "microsoft.network/locations/availableprivateendpointtypes", "microsoft.network/locations/baremetaltenants", "microsoft.network/locations/batchnotifyprivateendpointsforresourcemove", "microsoft.network/locations/batchvalidateprivateendpointsforresourcemove", "microsoft.network/locations/checkacceleratednetworkingsupport", "microsoft.network/locations/checkdnsnameavailability", "microsoft.network/locations/checkprivatelinkservicevisibility", "microsoft.network/locations/commitinternalazurenetworkmanagerconfiguration", "microsoft.network/locations/datatasks", "microsoft.network/locations/dnsresolveroperationresults", "microsoft.network/locations/dnsresolveroperationstatuses", "microsoft.network/locations/effectiveresourceownership", "microsoft.network/locations/getazurenetworkmanagerconfiguration", "microsoft.network/locations/nfvoperationresults", "microsoft.network/locations/internalazurevirtualnetworkmanageroperation", "microsoft.network/locations/nfvoperations", "microsoft.network/locations/operationresults", "microsoft.network/locations/operations", "microsoft.network/locations/perimeterassociableresourcetypes", "microsoft.network/locations/privatelinkservices", "microsoft.network/locations/publishresources", "microsoft.network/locations/querynetworksecurityperimeter", "microsoft.network/locations/servicetagdetails", "microsoft.network/locations/servicetags", "microsoft.network/locations/setazurenetworkmanagerconfiguration", "microsoft.network/locations/setloadbalancerfrontendpublicipaddresses", "microsoft.network/locations/setresourceownership", "microsoft.network/locations/supportedvirtualmachinesizes", "microsoft.network/locations/usages", "microsoft.network/locations/validateresourceownership", "microsoft.network/locations/virtualnetworkavailableendpointservices", "microsoft.network/natgateways", "microsoft.network/networkexperimentprofiles", "microsoft.network/networkexperimentprofiles/experiments", "microsoft.network/networkintentpolicies", "microsoft.network/networkinterfaces", "microsoft.network/networkinterfaces/tapconfigurations", "microsoft.network/networkmanagerconnections", "microsoft.network/networkmanagers", "microsoft.network/networkprofiles", "microsoft.network/networksecuritygroups", "microsoft.network/networksecuritygroups/securityrules", "microsoft.network/networksecurityperimeters", "microsoft.network/networkvirtualappliances", "microsoft.network/networkvirtualapplianceskus", "microsoft.network/networkwatchers", "microsoft.network/networkwatchers/connectionmonitors", "microsoft.network/networkwatchers/flowlogs", "microsoft.network/networkwatchers/lenses", "microsoft.network/networkwatchers/packetcaptures", "microsoft.network/networkwatchers/pingmeshes", "microsoft.network/operations", "microsoft.network/p2svpngateways", "microsoft.network/privatednsoperationresults", "microsoft.network/privatednsoperationstatuses", "microsoft.network/privatednszones", "microsoft.network/privatednszones/a", "microsoft.network/privatednszones/aaaa", "microsoft.network/privatednszones/all", "microsoft.network/privatednszones/cname", "microsoft.network/privatednszones/mx", "microsoft.network/privatednszones/ptr", "microsoft.network/privatednszones/soa", "microsoft.network/privatednszones/srv", "microsoft.network/privatednszones/txt", "microsoft.network/privatednszones/virtualnetworklinks", "microsoft.network/privateendpointredirectmaps", "microsoft.network/privatednszonesinternal", "microsoft.network/privateendpoints", "microsoft.network/privateendpoints/privatednszonegroups", "microsoft.network/privateendpoints/privatelinkserviceproxies", "microsoft.network/privatelinkservices", "microsoft.network/privatelinkservices/privateendpointconnections", "microsoft.network/publicipaddresses", "microsoft.network/publicipprefixes", "microsoft.network/routefilters", "microsoft.network/routefilters/routefilterrules", "microsoft.network/routetables", "microsoft.network/routetables/routes", "microsoft.network/securitypartnerproviders", "microsoft.network/serviceendpointpolicies", "microsoft.network/serviceendpointpolicies/serviceendpointpolicydefinitions", "microsoft.network/trafficmanagergeographichierarchies", "microsoft.network/trafficmanagerprofiles", "microsoft.network/trafficmanagerprofiles/heatmaps", "microsoft.network/trafficmanagerusermetricskeys", "microsoft.network/virtualhubs", "microsoft.network/virtualhubs/bgpconnections", "microsoft.network/virtualhubs/hubroutetables", "microsoft.network/virtualhubs/hubvirtualnetworkconnections", "microsoft.network/virtualhubs/ipconfigurations", "microsoft.network/virtualhubs/routetables", "microsoft.network/virtualhubs/routingintent", "microsoft.network/virtualnetworkgateways", "microsoft.network/virtualnetworks", "microsoft.network/virtualnetworks/listdnsforwardingrulesets", "microsoft.network/virtualnetworks/listdnsresolvers", "microsoft.network/virtualnetworks/listnetworkmanagereffectiveconnectivityconfigurations", "microsoft.network/virtualnetworks/listnetworkmanagereffectivesecurityadminrules", "microsoft.network/virtualnetworks/privatednszonelinks", "microsoft.network/virtualnetworks/subnets", "microsoft.network/virtualnetworks/subnets/contextualserviceendpointpolicies", "microsoft.network/virtualnetworks/subnets/resourcenavigationlinks", "microsoft.network/virtualnetworks/taggedtrafficconsumers", "microsoft.network/virtualnetworks/subnets/serviceassociationlinks", "microsoft.network/virtualnetworks/virtualnetworkpeerings", "microsoft.network/virtualnetworktaps", "microsoft.network/virtualrouters", "microsoft.network/virtualrouters/peerings", "microsoft.network/virtualwans", "microsoft.network/vpngateways", "microsoft.network/vpngateways/natrules", "microsoft.network/vpngateways/vpnconnections", "microsoft.network/vpnserverconfigurations", "microsoft.network/vpnsites", "microsoft.operationalinsights/clusters", "microsoft.operationalinsights/deletedworkspaces", "microsoft.operationalinsights/linktargets", "microsoft.operationalinsights/locations", "microsoft.operationalinsights/locations/operationstatuses", "microsoft.operationalinsights/operations", "microsoft.operationalinsights/querypacks", "microsoft.operationalinsights/storageinsightconfigs", "microsoft.operationalinsights/workspaces/dataexports", "microsoft.operationalinsights/workspaces/datasources", "microsoft.operationalinsights/workspaces/linkedservices", "microsoft.operationalinsights/workspaces/linkedstorageaccounts", "microsoft.operationalinsights/workspaces/metadata", "microsoft.operationalinsights/workspaces/networksecurityperimeterassociationproxies", "microsoft.operationalinsights/workspaces/networksecurityperimeterconfigurations", "microsoft.operationalinsights/workspaces/query", "microsoft.operationalinsights/workspaces/savedsearches", "microsoft.operationalinsights/workspaces/savedsearches/schedules", "microsoft.operationalinsights/workspaces/savedsearches/schedules/events", "microsoft.operationalinsights/workspaces/savedsearches/schedules/events/ticks", "microsoft.operationalinsights/workspaces/savedsearches/schedules/actions", "microsoft.operationalinsights/workspaces/scopedprivatelinkproxies", "microsoft.operationalinsights/workspaces/storageinsightconfigs", "microsoft.operationalinsights/workspaces/tables", "microsoft.operationalinsights/workspaces/views", "microsoft.operationsmanagement/managementassociations", "microsoft.operationsmanagement/operations", "microsoft.operationsmanagement/solutions", "microsoft.operationsmanagement/views", "microsoft.peering/cdnpeeringprefixes", "microsoft.peering/checkserviceprovideravailability", "microsoft.peering/legacypeerings", "microsoft.peering/lookingglass", "microsoft.peering/operations", "microsoft.peering/peerasns", "microsoft.peering/peerings", "microsoft.peering/peeringlocations", "microsoft.peering/peeringservicecountries", "microsoft.peering/peeringservicelocations", "microsoft.peering/peeringserviceproviders", "microsoft.peering/peeringservices", "microsoft.portal/consoles", "microsoft.portal/dashboards", "microsoft.portal/listtenantconfigurationviolations", "microsoft.portal/locations/consoles", "microsoft.portal/locations/usersettings", "microsoft.portal/locations", "microsoft.portal/operations", "microsoft.portal/tenantconfigurations", "microsoft.portal/usersettings", "microsoft.powerbi/locations", "microsoft.powerbi/locations/checknameavailability", "microsoft.powerbi/operations", "microsoft.powerbi/privatelinkservicesforpowerbi", "microsoft.powerbi/tenants", "microsoft.powerbi/privatelinkservicesforpowerbi/operationresults", "microsoft.powerbi/tenants/workspaces", "microsoft.powerbi/workspacecollections", "microsoft.providerhub/availableaccounts", "microsoft.providerhub/operationstatuses", "microsoft.providerhub/providerregistrations", "microsoft.providerhub/providerregistrations/checkinmanifest", "microsoft.providerhub/providerregistrations/customrollouts", "microsoft.providerhub/providerregistrations/resourceactions", "microsoft.providerhub/providerregistrations/defaultrollouts", "microsoft.providerhub/providerregistrations/resourcetyperegistrations", "microsoft.resources/builtintemplatespecs", "microsoft.resources/builtintemplatespecs/versions", "microsoft.resources/calculatetemplatehash", "microsoft.resources/bulkdelete", "microsoft.resources/changes", "microsoft.resources/checkpolicycompliance", "microsoft.resources/checkresourcename", "microsoft.resources/checkzonepeers", "microsoft.resources/deployments/operations", "microsoft.resources/deploymentscripts", "microsoft.resources/deployments", "microsoft.resources/deploymentscripts/logs", "microsoft.resources/deploymentstacks", "microsoft.resources/deploymentstacks/snapshots", "microsoft.resources/links", "microsoft.resources/locations", "microsoft.resources/locations/deploymentscriptoperationresults", "microsoft.resources/locations/deploymentstackoperationstatus", "microsoft.resources/notifyresourcejobs", "microsoft.resources/providers", "microsoft.resources/resourcegroups", "microsoft.resources/operationresults", "microsoft.resources/operations", "microsoft.resources/resources", "microsoft.resources/subscriptions", "microsoft.resources/subscriptions/locations", "microsoft.resources/subscriptions/operationresults", "microsoft.resources/subscriptions/providers", "microsoft.resources/subscriptions/resourcegroups", "microsoft.resources/subscriptions/resourcegroups/resources", "microsoft.resources/subscriptions/tagnames", "microsoft.resources/subscriptions/resources", "microsoft.resources/subscriptions/tagnames/tagvalues", "microsoft.resources/tags", "microsoft.resources/templatespecs", "microsoft.resources/templatespecs/versions", "microsoft.resources/tenants", "microsoft.search/searchservices/sharedprivatelinkresources", "microsoft.search/searchservices/privateendpointconnections", "microsoft.search/searchservices", "microsoft.search/resourcehealthmetadata", "microsoft.search/operations", "microsoft.search/checkservicenameavailability", "microsoft.search/checknameavailability", "microsoft.securityinsights/aggregations", "microsoft.securityinsights/alertrules", "microsoft.securityinsights/alertrules/actions", "microsoft.securityinsights/alertruletemplates", "microsoft.securityinsights/automationrules", "microsoft.securityinsights/bookmarks", "microsoft.securityinsights/cases", "microsoft.securityinsights/bookmarks/relations", "microsoft.securityinsights/cases/comments", "microsoft.securityinsights/dataconnectorscheckrequirements", "microsoft.securityinsights/dataconnectors", "microsoft.securityinsights/dataconnectordefinitions", "microsoft.securityinsights/confidentialwatchlists", "microsoft.securityinsights/enrichment", "microsoft.securityinsights/entities", "microsoft.securityinsights/entityqueries", "microsoft.securityinsights/entityquerytemplates", "microsoft.securityinsights/fileimports", "microsoft.securityinsights/huntsessions", "microsoft.securityinsights/incidents", "microsoft.securityinsights/incidents/comments", "microsoft.securityinsights/incidents/relations", "microsoft.securityinsights/listrepositories", "microsoft.securityinsights/metadata", "microsoft.securityinsights/mitrecoveragerecords", "microsoft.securityinsights/officeconsents", "microsoft.securityinsights/overview", "microsoft.securityinsights/onboardingstates", "microsoft.securityinsights/operations", "microsoft.securityinsights/recommendations", "microsoft.securityinsights/securitymlanalyticssettings", "microsoft.securityinsights/settings", "microsoft.securityinsights/sourcecontrols", "microsoft.securityinsights/threatintelligence", "microsoft.securityinsights/threatintelligence/indicators", "microsoft.securityinsights/watchlists", "microsoft.sql/checknameavailability", "microsoft.sql/locations", "microsoft.sql/instancepools", "microsoft.sql/locations/administratorazureasyncoperation", "microsoft.sql/locations/administratoroperationresults", "microsoft.sql/locations/advancedthreatprotectionazureasyncoperation", "microsoft.sql/locations/advancedthreatprotectionoperationresults", "microsoft.sql/locations/auditingsettingsazureasyncoperation", "microsoft.sql/locations/auditingsettingsoperationresults", "microsoft.sql/locations/capabilities", "microsoft.sql/locations/connectionpoliciesazureasyncoperation", "microsoft.sql/locations/connectionpoliciesoperationresults", "microsoft.sql/locations/databaseazureasyncoperation", "microsoft.sql/locations/databaseencryptionprotectorrevalidateazureasyncoperation", "microsoft.sql/locations/databaseencryptionprotectorrevalidateoperationresults", "microsoft.sql/locations/databaseencryptionprotectorrevertazureasyncoperation", "microsoft.sql/locations/databaseencryptionprotectorrevertoperationresults", "microsoft.sql/locations/databaseoperationresults", "microsoft.sql/locations/databaserestoreazureasyncoperation", "microsoft.sql/locations/deletevirtualnetworkorsubnetsazureasyncoperation", "microsoft.sql/locations/deletevirtualnetworkorsubnets", "microsoft.sql/locations/deletevirtualnetworkorsubnetsoperationresults", "microsoft.sql/locations/devopsauditingsettingsazureasyncoperation", "microsoft.sql/locations/devopsauditingsettingsoperationresults", "microsoft.sql/locations/distributedavailabilitygroupsazureasyncoperation", "microsoft.sql/locations/distributedavailabilitygroupsoperationresults", "microsoft.sql/locations/dnsaliasoperationresults", "microsoft.sql/locations/dnsaliasasyncoperation", "microsoft.sql/locations/elasticpoolazureasyncoperation", "microsoft.sql/locations/elasticpooloperationresults", "microsoft.sql/locations/encryptionprotectorazureasyncoperation", "microsoft.sql/locations/encryptionprotectoroperationresults", "microsoft.sql/locations/extendedauditingsettingsazureasyncoperation", "microsoft.sql/locations/extendedauditingsettingsoperationresults", "microsoft.sql/locations/externalpolicybasedauthorizationsazureasycoperation", "microsoft.sql/locations/externalpolicybasedauthorizationsoperationresults", "microsoft.sql/locations/failovergroupazureasyncoperation", "microsoft.sql/locations/failovergroupoperationresults", "microsoft.sql/locations/firewallrulesazureasyncoperation", "microsoft.sql/locations/firewallrulesoperationresults", "microsoft.sql/locations/importexportazureasyncoperation", "microsoft.sql/locations/importexportoperationresults", "microsoft.sql/locations/instancefailovergroupazureasyncoperation", "microsoft.sql/locations/instancefailovergroupoperationresults", "microsoft.sql/locations/instancefailovergroups", "microsoft.sql/locations/instancepoolazureasyncoperation", "microsoft.sql/locations/instancepooloperationresults", "microsoft.sql/locations/jobagentazureasyncoperation", "microsoft.sql/locations/jobagentoperationresults", "microsoft.sql/locations/ledgerdigestuploadsazureasyncoperation", "microsoft.sql/locations/ledgerdigestuploadsoperationresults", "microsoft.sql/locations/longtermretentionbackupazureasyncoperation", "microsoft.sql/locations/longtermretentionbackupoperationresults", "microsoft.sql/locations/longtermretentionbackups", "microsoft.sql/locations/longtermretentionmanagedinstancebackupazureasyncoperation", "microsoft.sql/locations/longtermretentionmanagedinstancebackupoperationresults", "microsoft.sql/locations/longtermretentionmanagedinstancebackups", "microsoft.sql/locations/longtermretentionmanagedinstances", "microsoft.sql/locations/longtermretentionpolicyazureasyncoperation", "microsoft.sql/locations/longtermretentionservers", "microsoft.sql/locations/longtermretentionpolicyoperationresults", "microsoft.sql/locations/manageddatabaseazureasyncoperation", "microsoft.sql/locations/manageddatabasecompleterestoreazureasyncoperation", "microsoft.sql/locations/manageddatabasecompleterestoreoperationresults", "microsoft.sql/locations/manageddatabasemoveazureasyncoperation", "microsoft.sql/locations/manageddatabasemoveoperationresults", "microsoft.sql/locations/manageddatabaseoperationresults", "microsoft.sql/locations/manageddatabaserestoreazureasyncoperation", "microsoft.sql/locations/manageddatabaserestoreoperationresults", "microsoft.sql/locations/manageddnsaliasasyncoperation", "microsoft.sql/locations/manageddnsaliasoperationresults", "microsoft.sql/locations/managedinstanceadvancedthreatprotectionazureasyncoperation", "microsoft.sql/locations/managedinstanceadvancedthreatprotectionoperationresults", "microsoft.sql/locations/managedinstanceazureasyncoperation", "microsoft.sql/locations/managedinstancedtcazureasyncoperation", "microsoft.sql/locations/managedinstanceencryptionprotectoroperationresults", "microsoft.sql/locations/managedinstanceencryptionprotectorazureasyncoperation", "microsoft.sql/locations/managedinstancekeyazureasyncoperation", "microsoft.sql/locations/managedinstancekeyoperationresults", "microsoft.sql/locations/managedinstancelongtermretentionpolicyazureasyncoperation", "microsoft.sql/locations/managedinstancelongtermretentionpolicyoperationresults", "microsoft.sql/locations/managedinstanceoperationresults", "microsoft.sql/locations/managedinstanceprivateendpointconnectionazureasyncoperation", "microsoft.sql/locations/managedinstanceprivateendpointconnectionoperationresults", "microsoft.sql/locations/managedinstanceprivateendpointconnectionproxyazureasyncoperation", "microsoft.sql/locations/managedinstanceprivateendpointconnectionproxyoperationresults", "microsoft.sql/locations/managedinstancetdecertazureasyncoperation", "microsoft.sql/locations/managedinstancetdecertoperationresults", "microsoft.sql/locations/managedserversecurityalertpoliciesazureasyncoperation", "microsoft.sql/locations/managedserversecurityalertpoliciesoperationresults", "microsoft.sql/locations/managedshorttermretentionpolicyazureasyncoperation", "microsoft.sql/locations/managedtransparentdataencryptionazureasyncoperation", "microsoft.sql/locations/managedshorttermretentionpolicyoperationresults", "microsoft.sql/locations/managedtransparentdataencryptionoperationresults", "microsoft.sql/locations/notifyazureasyncoperation", "microsoft.sql/locations/notifynetworksecurityperimeterupdatesavailable", "microsoft.sql/locations/outboundfirewallrulesazureasyncoperation", "microsoft.sql/locations/outboundfirewallrulesoperationresults", "microsoft.sql/locations/privateendpointconnectionoperationresults", "microsoft.sql/locations/privateendpointconnectionproxyazureasyncoperation", "microsoft.sql/locations/privateendpointconnectionazureasyncoperation", "microsoft.sql/locations/privateendpointconnectionproxyoperationresults", "microsoft.sql/locations/securityalertpoliciesazureasyncoperation", "microsoft.sql/locations/securityalertpoliciesoperationresults", "microsoft.sql/locations/replicationlinksazureasyncoperation", "microsoft.sql/locations/replicationlinksoperationresults", "microsoft.sql/locations/serveradministratorazureasyncoperation", "microsoft.sql/locations/serveradministratoroperationresults", "microsoft.sql/locations/serverazureasyncoperation", "microsoft.sql/locations/serverkeyazureasyncoperation", "microsoft.sql/locations/serverkeyoperationresults", "microsoft.sql/locations/serveroperationresults", "microsoft.sql/locations/servertrustcertificatesazureasyncoperation", "microsoft.sql/locations/servertrustcertificatesoperationresults", "microsoft.sql/locations/servertrustgroupazureasyncoperation", "microsoft.sql/locations/servertrustgroupoperationresults", "microsoft.sql/locations/servertrustgroups", "microsoft.sql/locations/shorttermretentionpolicyazureasyncoperation", "microsoft.sql/locations/shorttermretentionpolicyoperationresults", "microsoft.sql/locations/sqlvulnerabilityassessmentazureasyncoperation", "microsoft.sql/locations/sqlvulnerabilityassessmentoperationresults", "microsoft.sql/locations/startmanagedinstanceazureasyncoperation", "microsoft.sql/locations/startmanagedinstanceoperationresults", "microsoft.sql/locations/stopmanagedinstanceazureasyncoperation", "microsoft.sql/locations/stopmanagedinstanceoperationresults", "microsoft.sql/locations/syncagentoperationresults", "microsoft.sql/locations/syncdatabaseids", "microsoft.sql/locations/syncgroupoperationresults", "microsoft.sql/locations/syncmemberoperationresults", "microsoft.sql/locations/tdecertazureasyncoperation", "microsoft.sql/locations/transparentdataencryptionoperationresults", "microsoft.sql/locations/tdecertoperationresults", "microsoft.sql/locations/transparentdataencryptionazureasyncoperation", "microsoft.sql/locations/usages", "microsoft.sql/locations/virtualclusterazureasyncoperation", "microsoft.sql/locations/virtualclusteroperationresults", "microsoft.sql/locations/virtualnetworkrulesazureasyncoperation", "microsoft.sql/locations/virtualnetworkrulesoperationresults", "microsoft.sql/locations/vulnerabilityassessmentscanazureasyncoperation", "microsoft.sql/locations/vulnerabilityassessmentscanoperationresults", "microsoft.sql/managedinstances", "microsoft.sql/managedinstances/administrators", "microsoft.sql/managedinstances/advancedthreatprotectionsettings", "microsoft.sql/managedinstances/azureadonlyauthentications", "microsoft.sql/managedinstances/databases/advancedthreatprotectionsettings", "microsoft.sql/managedinstances/databases", "microsoft.sql/managedinstances/databases/backuplongtermretentionpolicies", "microsoft.sql/managedinstances/databases/schemas/tables/columns/sensitivitylabels", "microsoft.sql/managedinstances/databases/backupshorttermretentionpolicies", "microsoft.sql/managedinstances/databases/securityalertpolicies", "microsoft.sql/managedinstances/databases/transparentdataencryption", "microsoft.sql/managedinstances/databases/vulnerabilityassessments", "microsoft.sql/managedinstances/databases/vulnerabilityassessments/rules/baselines", "microsoft.sql/managedinstances/distributedavailabilitygroups", "microsoft.sql/managedinstances/dnsaliases", "microsoft.sql/managedinstances/encryptionprotector", "microsoft.sql/managedinstances/keys", "microsoft.sql/managedinstances/metricdefinitions", "microsoft.sql/managedinstances/metrics", "microsoft.sql/managedinstances/privateendpointconnections", "microsoft.sql/managedinstances/recoverabledatabases", "microsoft.sql/managedinstances/restorabledroppeddatabases/backupshorttermretentionpolicies", "microsoft.sql/managedinstances/securityalertpolicies", "microsoft.sql/managedinstances/sqlagent", "microsoft.sql/managedinstances/start", "microsoft.sql/managedinstances/servertrustcertificates", "microsoft.sql/managedinstances/startstopschedules", "microsoft.sql/managedinstances/stop", "microsoft.sql/managedinstances/tdecertificates", "microsoft.sql/servers", "microsoft.sql/operations", "microsoft.sql/managedinstances/vulnerabilityassessments", "microsoft.sql/servers/administratoroperationresults", "microsoft.sql/servers/administrators", "microsoft.sql/servers/advancedthreatprotectionsettings", "microsoft.sql/servers/advisors", "microsoft.sql/servers/aggregateddatabasemetrics", "microsoft.sql/servers/auditingpolicies", "microsoft.sql/servers/auditingsettings", "microsoft.sql/servers/automatictuning", "microsoft.sql/servers/azureadonlyauthentications", "microsoft.sql/servers/backuplongtermretentionvaults", "microsoft.sql/servers/communicationlinks", "microsoft.sql/servers/connectionpolicies", "microsoft.sql/servers/databases", "microsoft.sql/servers/databases/activate", "microsoft.sql/servers/databases/activatedatabase", "microsoft.sql/servers/databases/advancedthreatprotectionsettings", "microsoft.sql/servers/databases/advisors", "microsoft.sql/servers/databases/advisors/recommendedactions", "microsoft.sql/servers/databases/auditingpolicies", "microsoft.sql/servers/databases/auditingsettings", "microsoft.sql/servers/databases/auditrecords", "microsoft.sql/servers/databases/backuplongtermretentionpolicies", "microsoft.sql/servers/databases/automatictuning", "microsoft.sql/servers/databases/backupshorttermretentionpolicies", "microsoft.sql/servers/databases/connectionpolicies", "microsoft.sql/servers/databases/databasestate", "microsoft.sql/servers/databases/datamaskingpolicies", "microsoft.sql/servers/databases/datamaskingpolicies/rules", "microsoft.sql/servers/databases/deactivate", "microsoft.sql/servers/databases/deactivatedatabase", "microsoft.sql/servers/databases/extendedauditingsettings", "microsoft.sql/servers/databases/extensions", "microsoft.sql/servers/databases/geobackuppolicies", "microsoft.sql/servers/databases/ledgerdigestuploads", "microsoft.sql/servers/databases/maintenancewindows", "microsoft.sql/servers/databases/metricdefinitions", "microsoft.sql/servers/databases/metrics", "microsoft.sql/servers/databases/securityalertpolicies", "microsoft.sql/servers/databases/recommendedsensitivitylabels", "microsoft.sql/servers/databases/schemas/tables/columns/sensitivitylabels", "microsoft.sql/servers/databases/sqlvulnerabilityassessments", "microsoft.sql/servers/databases/syncgroups/syncmembers", "microsoft.sql/servers/databases/syncgroups", "microsoft.sql/servers/databases/topqueries", "microsoft.sql/servers/databases/topqueries/querytext", "microsoft.sql/servers/databases/transparentdataencryption", "microsoft.sql/servers/databases/vulnerabilityassessment", "microsoft.sql/servers/databases/vulnerabilityassessments/rules/baselines", "microsoft.sql/servers/databases/vulnerabilityassessments", "microsoft.sql/servers/databases/vulnerabilityassessmentscans", "microsoft.sql/servers/databases/workloadgroups/workloadclassifiers", "microsoft.sql/servers/databases/vulnerabilityassessmentsettings", "microsoft.sql/servers/databases/workloadgroups", "microsoft.sql/servers/databasesecuritypolicies", "microsoft.sql/servers/devopsauditingsettings", "microsoft.sql/servers/dnsaliases", "microsoft.sql/servers/disasterrecoveryconfiguration", "microsoft.sql/servers/elasticpoolestimates", "microsoft.sql/servers/elasticpools", "microsoft.sql/servers/elasticpools/advisors", "microsoft.sql/servers/elasticpools/metricdefinitions", "microsoft.sql/servers/elasticpools/metrics", "microsoft.sql/servers/encryptionprotector", "microsoft.sql/servers/extendedauditingsettings", "microsoft.sql/servers/failovergroups", "microsoft.sql/servers/firewallrules", "microsoft.sql/servers/import", "microsoft.sql/servers/importexportoperationresults", "microsoft.sql/servers/jobaccounts", "microsoft.sql/servers/jobagents", "microsoft.sql/servers/jobagents/credentials", "microsoft.sql/servers/jobagents/jobs/executions", "microsoft.sql/servers/jobagents/jobs/steps", "microsoft.sql/servers/jobagents/jobs", "microsoft.sql/servers/jobagents/targetgroups", "microsoft.sql/servers/keys", "microsoft.sql/servers/operationresults", "microsoft.sql/servers/outboundfirewallrules", "microsoft.sql/servers/privateendpointconnections", "microsoft.sql/servers/recommendedelasticpools", "microsoft.sql/servers/restorabledroppeddatabases", "microsoft.sql/servers/securityalertpolicies", "microsoft.sql/servers/recoverabledatabases", "microsoft.sql/servers/serviceobjectives", "microsoft.sql/servers/sqlvulnerabilityassessments", "microsoft.sql/servers/syncagents", "microsoft.sql/servers/tdecertificates", "microsoft.sql/servers/usages", "microsoft.sql/servers/virtualnetworkrules", "microsoft.sql/servers/vulnerabilityassessments", "microsoft.sql/virtualclusters", "microsoft.storage/checknameavailability", "microsoft.storage/datamovers", "microsoft.storage/datamovers/agents", "microsoft.storage/datamovers/endpoints", "microsoft.storage/datamovers/projects", "microsoft.storage/datamovers/projects/jobdefinitions", "microsoft.storage/datamovers/projects/jobdefinitions/jobruns", "microsoft.storage/deletedaccounts", "microsoft.storage/locations", "microsoft.storage/locations/asyncoperations", "microsoft.storage/locations/deletedaccounts", "microsoft.storage/locations/checknameavailability", "microsoft.storage/locations/deletevirtualnetworkorsubnets", "microsoft.storage/locations/usages", "microsoft.storage/operations", "microsoft.storage/storageaccounts", "microsoft.storage/storageaccounts/blobservices", "microsoft.storage/storageaccounts/blobservices/containers/immutabilitypolicies", "microsoft.storage/storageaccounts/encryptionscopes", "microsoft.storage/storageaccounts/fileservices", "microsoft.storage/storageaccounts/fileservices/shares", "microsoft.storage/storageaccounts/inventorypolicies", "microsoft.storage/storageaccounts/listservicesas", "microsoft.storage/storageaccounts/listaccountsas", "microsoft.storage/storageaccounts/localusers", "microsoft.storage/storageaccounts/managementpolicies", "microsoft.storage/storageaccounts/objectreplicationpolicies", "microsoft.storage/storageaccounts/privateendpointconnectionproxies", "microsoft.storage/storageaccounts/privateendpointconnections", "microsoft.storage/storageaccounts/queueservices", "microsoft.storage/storageaccounts/queueservices/queues", "microsoft.storage/storageaccounts/services", "microsoft.storage/storageaccounts/services/metricdefinitions", "microsoft.storage/storageaccounts/storagetaskassignments", "microsoft.storage/storageaccounts/tableservices", "microsoft.storage/storageaccounts/tableservices/tables", "microsoft.storage/storagetasks", "microsoft.storage/usages", "microsoft.subscription/acceptchangetenant", "microsoft.subscription/acceptownership", "microsoft.subscription/acceptownershipstatus", "microsoft.subscription/aliases", "microsoft.subscription/cancel", "microsoft.subscription/changetenantrequest", "microsoft.subscription/changetenantstatus", "microsoft.subscription/createsubscription", "microsoft.subscription/enable", "microsoft.subscription/operationresults", "microsoft.subscription/policies", "microsoft.subscription/operations", "microsoft.subscription/rename", "microsoft.subscription/subscriptionoperations", "microsoft.subscription/subscriptiondefinitions", "microsoft.subscription/subscriptions", "microsoft.support/checknameavailability", "microsoft.support/lookupresourceid", "microsoft.support/operationresults", "microsoft.support/operations", "microsoft.support/services", "microsoft.support/operationsstatus", "microsoft.support/services/problemclassifications", "microsoft.support/supporttickets", "microsoft.virtualmachineimages/imagetemplates", "microsoft.virtualmachineimages/imagetemplates/runoutputs", "microsoft.virtualmachineimages/locations", "microsoft.virtualmachineimages/locations/operations", "microsoft.virtualmachineimages/operations", "microsoft.web/apimanagementaccounts", "microsoft.web/apimanagementaccounts/apiacls", "microsoft.web/apimanagementaccounts/apis", "microsoft.web/apimanagementaccounts/apis/apiacls", "microsoft.web/apimanagementaccounts/apis/connectionacls", "microsoft.web/apimanagementaccounts/apis/connections", "microsoft.web/apimanagementaccounts/apis/connections/connectionacls", "microsoft.web/apimanagementaccounts/apis/localizeddefinitions", "microsoft.web/apimanagementaccounts/connectionacls", "microsoft.web/availablestacks", "microsoft.web/billingmeters", "microsoft.web/certificates", "microsoft.web/apimanagementaccounts/connections", "microsoft.web/checknameavailability", "microsoft.web/connectiongateways", "microsoft.web/connections", "microsoft.web/containerapps", "microsoft.web/customapis", "microsoft.web/customhostnamesites", "microsoft.web/deletedsites", "microsoft.web/functionappstacks", "microsoft.web/deploymentlocations", "microsoft.web/georegions", "microsoft.web/generategithubaccesstokenforappservicecli", "microsoft.web/hostingenvironments", "microsoft.web/hostingenvironments/configurations", "microsoft.web/hostingenvironments/eventgridfilters", "microsoft.web/hostingenvironments/metricdefinitions", "microsoft.web/hostingenvironments/metrics", "microsoft.web/hostingenvironments/multirolepools", "microsoft.web/hostingenvironments/multirolepools/instances", "microsoft.web/hostingenvironments/multirolepools/instances/metricdefinitions", "microsoft.web/hostingenvironments/multirolepools/instances/metrics", "microsoft.web/hostingenvironments/multirolepools/metricdefinitions", "microsoft.web/hostingenvironments/multirolepools/metrics", "microsoft.web/hostingenvironments/privateendpointconnections", "microsoft.web/hostingenvironments/workerpools", "microsoft.web/hostingenvironments/workerpools/instances", "microsoft.web/hostingenvironments/workerpools/instances/metricdefinitions", "microsoft.web/hostingenvironments/workerpools/instances/metrics", "microsoft.web/hostingenvironments/workerpools/metricdefinitions", "microsoft.web/hostingenvironments/workerpools/metrics", "microsoft.web/ishostingenvironmentnameavailable", "microsoft.web/ishostnameavailable", "microsoft.web/isusernameavailable", "microsoft.web/kubeenvironments", "microsoft.web/listsitesassignedtohostname", "microsoft.web/locations", "microsoft.web/locations/apioperations", "microsoft.web/locations/connectiongatewayinstallations", "microsoft.web/locations/deletedsites", "microsoft.web/locations/deletevirtualnetworkorsubnets", "microsoft.web/locations/extractapidefinitionfromwsdl", "microsoft.web/locations/functionappstacks", "microsoft.web/locations/getnetworkpolicies", "microsoft.web/locations/operations", "microsoft.web/locations/managedapis", "microsoft.web/locations/listwsdlinterfaces", "microsoft.web/locations/operationresults", "microsoft.web/locations/previewstaticsiteworkflowfile", "microsoft.web/locations/runtimes", "microsoft.web/locations/validatedeletevirtualnetworkorsubnets", "microsoft.web/locations/webappstacks", "microsoft.web/operations", "microsoft.web/publishingusers", "microsoft.web/recommendations", "microsoft.web/resourcehealthmetadata", "microsoft.web/runtimes", "microsoft.web/serverfarms", "microsoft.web/serverfarms/eventgridfilters", "microsoft.web/serverfarms/firstpartyapps/keyvaultsettings", "microsoft.web/serverfarms/firstpartyapps", "microsoft.web/serverfarms/metricdefinitions", "microsoft.web/serverfarms/metrics", "microsoft.web/serverfarms/virtualnetworkconnections/gateways", "microsoft.web/serverfarms/virtualnetworkconnections/routes", "microsoft.web/serverfarms/workers", "microsoft.web/sites", "microsoft.web/sites/basicpublishingcredentialspolicies", "microsoft.web/sites/basicpublishingcredentialspolicies/ftp", "microsoft.web/sites/basicpublishingcredentialspolicies/scm", "microsoft.web/sites/config", "microsoft.web/sites/domainownershipidentifiers", "microsoft.web/sites/eventgridfilters", "microsoft.web/sites/extensions", "microsoft.web/sites/functions", "microsoft.web/sites/functions/keys", "microsoft.web/sites/hostnamebindings", "microsoft.web/sites/hybridconnection", "microsoft.web/sites/hybridconnectionnamespaces/relays", "microsoft.web/sites/instances", "microsoft.web/sites/metricdefinitions", "microsoft.web/sites/metrics", "microsoft.web/sites/networkconfig", "microsoft.web/sites/premieraddons", "microsoft.web/sites/privateaccess", "microsoft.web/sites/privateendpointconnections", "microsoft.web/sites/publiccertificates", "microsoft.web/sites/recommendations", "microsoft.web/sites/resourcehealthmetadata", "microsoft.web/sites/siteextensions", "microsoft.web/sites/slots", "microsoft.web/sites/slots/basicpublishingcredentialspolicies", "microsoft.web/sites/slots/config", "microsoft.web/sites/slots/domainownershipidentifiers", "microsoft.web/sites/slots/eventgridfilters", "microsoft.web/sites/slots/extensions", "microsoft.web/sites/slots/hostnamebindings", "microsoft.web/sites/slots/hybridconnection", "microsoft.web/sites/slots/hybridconnectionnamespaces/relays", "microsoft.web/sites/slots/instances", "microsoft.web/sites/slots/metricdefinitions", "microsoft.web/sites/slots/metrics", "microsoft.web/sites/slots/premieraddons", "microsoft.web/sites/slots/networkconfig", "microsoft.web/sites/slots/publiccertificates", "microsoft.web/sites/slots/sourcecontrols", "microsoft.web/sites/slots/virtualnetworkconnections", "microsoft.web/sites/slots/virtualnetworkconnections/gateways", "microsoft.web/sites/sourcecontrols", "microsoft.web/sites/virtualnetworkconnections", "microsoft.web/sites/virtualnetworkconnections/gateways", "microsoft.web/sourcecontrols", "microsoft.web/staticsites", "microsoft.web/staticsites/builds", "microsoft.web/staticsites/builds/linkedbackends", "microsoft.web/staticsites/builds/userprovidedfunctionapps", "microsoft.web/staticsites/linkedbackends", "microsoft.web/staticsites/privateendpointconnections", "microsoft.web/staticsites/userprovidedfunctionapps", "microsoft.web/validate","microsoft.web/verifyhostingenvironmentvnet","microsoft.web/webappstacks","microsoft.web/workerapps","microsoft.operationalinsights/workspaces","Microsoft.Compute", "Microsoft.Network", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Monitor", "Microsoft.Automation", "Microsoft.App",  "microsoft.operationalinsights/workspaces", "microsoft.advisor/advisorscore", "microsoft.advisor/configurations", "microsoft.advisor/generaterecommendations", "microsoft.advisor/metadata", "microsoft.advisor/operations", "microsoft.advisor/predict", "microsoft.alertsmanagement/actionrules", "microsoft.alertsmanagement/alerts", "microsoft.alertsmanagement/alertsmetadata", "microsoft.alertsmanagement/migratefromsmartdetection", "microsoft.alertsmanagement/alertssummary", "microsoft.alertsmanagement/operations", "microsoft.alertsmanagement/prometheusrulegroups", "microsoft.alertsmanagement/smartdetectoralertrules", "microsoft.alertsmanagement/smartgroups", "microsoft.authorization/locks", "microsoft.authorization/operations", "microsoft.authorization/operationstatus", "microsoft.authorization/permissions", "microsoft.authorization/policyexemptions", "microsoft.authorization/policydefinitions", "microsoft.authorization/policysetdefinitions", "microsoft.authorization/privatelinkassociations", "microsoft.authorization/provideroperations", "microsoft.authorization/resourcemanagementprivatelinks", "microsoft.authorization/roleassignmentapprovals", "microsoft.authorization/roleassignments", "microsoft.authorization/roleassignmentscheduleinstances", "microsoft.authorization/roleassignmentschedulerequests", "microsoft.authorization/eligiblechildresources", "microsoft.authorization/elevateaccess", "microsoft.authorization/denyassignments", "microsoft.authorization/classicadministrators", "microsoft.authorization/checkaccess", "microsoft.authorization/policyassignments", "microsoft.authorization/roleassignmentschedules", "microsoft.authorization/roleassignmentsusagemetrics", "microsoft.authorization/roledefinitions", "microsoft.authorization/findorphanroleassignments", "microsoft.authorization/diagnosticsettingscategories", "microsoft.authorization/diagnosticsettings", "microsoft.authorization/datapolicymanifests", "microsoft.authorization/dataaliases", "microsoft.authorization/accessreviewschedulesettings", "microsoft.authorization/batchresourcecheckaccess", "microsoft.authorization/accessreviewscheduledefinitions", "microsoft.authorization/accessreviewhistorydefinitions", "microsoft.authorization/roleeligibilityscheduleinstances", "microsoft.authorization/roleeligibilityschedulerequests", "microsoft.authorization/roleeligibilityschedules", "microsoft.authorization/rolemanagementpolicies", "microsoft.authorization/rolemanagementpolicyassignments", "microsoft.automation/automationaccounts", "microsoft.automation/automationaccounts/agentregistrationinformation", "microsoft.automation/automationaccounts/certificates", "microsoft.automation/automationaccounts/compilationjobs", "microsoft.automation/automationaccounts/configurations", "microsoft.automation/automationaccounts/connections", "microsoft.automation/automationaccounts/connectiontypes", "microsoft.automation/automationaccounts/credentials", "microsoft.automation/automationaccounts/hybridrunbookworkergroups/hybridrunbookworkers", "microsoft.automation/automationaccounts/jobs", "microsoft.automation/automationaccounts/hybridrunbookworkergroups", "microsoft.automation/automationaccounts/jobschedules", "microsoft.automation/automationaccounts/modules", "microsoft.automation/automationaccounts/nodeconfigurations", "microsoft.automation/automationaccounts/nodes", "microsoft.automation/automationaccounts/privateendpointconnectionproxies", "microsoft.automation/automationaccounts/privateendpointconnections", "microsoft.automation/automationaccounts/privatelinkresources", "microsoft.automation/automationaccounts/python2packages", "microsoft.automation/automationaccounts/runbooks", "microsoft.automation/automationaccounts/schedules", "microsoft.automation/automationaccounts/softwareupdateconfigurationmachineruns", "microsoft.automation/automationaccounts/softwareupdateconfigurationruns", "microsoft.automation/automationaccounts/softwareupdateconfigurations", "microsoft.automation/automationaccounts/variables", "microsoft.automation/automationaccounts/watchers", "microsoft.automation/automationaccounts/webhooks", "microsoft.automation/deletedautomationaccounts", "microsoft.automation/operations", "microsoft.azuredata/sqlserverregistrations/sqlservers", "microsoft.azuredata/sqlserverregistrations", "microsoft.azuredata/operations", "microsoft.backupsolutions/locations", "microsoft.backupsolutions/locations/operationstatuses", "microsoft.backupsolutions/operations", "microsoft.backupsolutions/vmwareapplications", "microsoft.billing/billingaccounts/appliedreservationorders", "microsoft.billing/billingaccounts", "microsoft.billing/billingaccounts/agreements", "microsoft.billing/billingaccounts/associatedtenants", "microsoft.billing/billingaccounts/availablebalance", "microsoft.billing/billingaccounts/billingpermissions", "microsoft.billing/billingaccounts/billingprofiles", "microsoft.billing/billingaccounts/billingprofiles/availablebalance", "microsoft.billing/billingaccounts/billingprofiles/billingpermissions", "microsoft.billing/billingaccounts/billingprofiles/billingroleassignments", "microsoft.billing/billingaccounts/billingprofiles/billingroledefinitions", "microsoft.billing/billingaccounts/billingprofiles/billingsubscriptions", "microsoft.billing/billingaccounts/billingprofiles/createbillingroleassignment", "microsoft.billing/billingaccounts/billingprofiles/customers", "microsoft.billing/billingaccounts/billingprofiles/instructions", "microsoft.billing/billingaccounts/billingprofiles/invoices", "microsoft.billing/billingaccounts/billingprofiles/invoices/pricesheet", "microsoft.billing/billingaccounts/billingprofiles/invoices/transactions", "microsoft.billing/billingaccounts/billingprofiles/invoicesections", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/billingpermissions", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/billingroleassignments", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/billingroledefinitions", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/billingsubscriptions", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/createbillingroleassignment", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/initiatetransfer", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/products", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/products/transfer", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/products/updateautorenew", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/transactions", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/transfers", "microsoft.billing/billingaccounts/billingprofiles/invoicesections/validatedeleteinvoicesectioneligibility", "microsoft.billing/billingaccounts/billingprofiles/patchoperations", "microsoft.billing/billingaccounts/billingprofiles/paymentmethodlinks", "microsoft.billing/billingaccounts/billingprofiles/paymentmethods", "microsoft.billing/billingaccounts/billingprofiles/policies", "microsoft.billing/billingaccounts/billingprofiles/pricesheet", "microsoft.billing/billingaccounts/billingprofiles/pricesheetdownloadoperations", "microsoft.billing/billingaccounts/billingprofiles/products", "microsoft.billing/billingaccounts/billingprofiles/reservations", "microsoft.billing/billingaccounts/billingprofiles/transactions", "microsoft.billing/billingaccounts/billingprofiles/validatedeletebillingprofileeligibility", "microsoft.billing/billingaccounts/billingroleassignments", "microsoft.billing/billingaccounts/billingroledefinitions", "microsoft.billing/billingaccounts/billingprofiles/validatedetachpaymentmethodeligibility", "microsoft.billing/billingaccounts/billingsubscriptionaliases", "microsoft.billing/billingaccounts/billingsubscriptions", "microsoft.billing/billingaccounts/billingsubscriptions/elevaterole", "microsoft.billing/billingaccounts/billingsubscriptions/invoices", "microsoft.billing/billingaccounts/createinvoicesectionoperations", "microsoft.billing/billingaccounts/createbillingroleassignment", "microsoft.billing/billingaccounts/customers", "microsoft.billing/billingaccounts/customers/billingpermissions", "microsoft.billing/billingaccounts/customers/billingsubscriptions", "microsoft.billing/billingaccounts/customers/initiatetransfer", "microsoft.billing/billingaccounts/customers/policies", "microsoft.billing/billingaccounts/customers/products", "microsoft.billing/billingaccounts/customers/transactions", "microsoft.billing/billingaccounts/customers/transfers", "microsoft.billing/billingaccounts/customers/transfersupportedaccounts", "microsoft.billing/billingaccounts/departments", "microsoft.billing/billingaccounts/departments/billingpermissions", "microsoft.billing/billingaccounts/departments/billingroleassignments", "microsoft.billing/billingaccounts/departments/billingroledefinitions", "microsoft.billing/billingaccounts/departments/billingsubscriptions", "microsoft.billing/billingaccounts/departments/enrollmentaccounts", "microsoft.billing/billingaccounts/enrollmentaccounts", "microsoft.billing/billingaccounts/enrollmentaccounts/billingpermissions", "microsoft.billing/billingaccounts/enrollmentaccounts/billingroleassignments", "microsoft.billing/billingaccounts/enrollmentaccounts/billingroledefinitions", "microsoft.billing/billingaccounts/enrollmentaccounts/billingsubscriptions", "microsoft.billing/billingaccounts/invoices", "microsoft.billing/billingaccounts/invoices/transactions", "microsoft.billing/billingaccounts/invoices/transactionsummary", "microsoft.billing/billingaccounts/invoicesections", "microsoft.billing/billingaccounts/invoicesections/billingsubscriptionmoveoperations", "microsoft.billing/billingaccounts/invoicesections/billingsubscriptions", "microsoft.billing/billingaccounts/invoicesections/billingsubscriptions/transfer", "microsoft.billing/billingaccounts/invoicesections/elevate", "microsoft.billing/billingaccounts/invoicesections/initiatetransfer", "microsoft.billing/billingaccounts/invoicesections/patchoperations", "microsoft.billing/billingaccounts/invoicesections/products", "microsoft.billing/billingaccounts/invoicesections/productmoveoperations", "microsoft.billing/billingaccounts/invoicesections/products/transfer", "microsoft.billing/billingaccounts/invoicesections/products/updateautorenew", "microsoft.billing/billingaccounts/invoicesections/producttransfersresults", "microsoft.billing/billingaccounts/invoicesections/transfers", "microsoft.billing/billingaccounts/invoicesections/transactions", "microsoft.billing/billingaccounts/lineofcredit", "microsoft.billing/billingaccounts/operationresults", "microsoft.billing/billingaccounts/notificationcontacts", "microsoft.billing/billingaccounts/listinvoicesectionswithcreatesubscriptionpermission", "microsoft.billing/billingaccounts/patchoperations", "microsoft.billing/billingaccounts/payableoverage", "microsoft.billing/billingaccounts/paymentmethods", "microsoft.billing/billingaccounts/permissionrequests", "microsoft.billing/billingaccounts/paynow", "microsoft.billing/billingaccounts/policies", "microsoft.billing/billingaccounts/products", "microsoft.billing/billingaccounts/promotionalcredits", "microsoft.billing/billingaccounts/reservations", "microsoft.billing/billingaccounts/savingsplanorders", "microsoft.billing/billingaccounts/savingsplanorders/savingsplans", "microsoft.billing/billingaccounts/savingsplans", "microsoft.billing/billingaccounts/transactions", "microsoft.billing/billingperiods", "microsoft.billing/billingpermissions", "microsoft.billing/billingproperty", "microsoft.billing/billingroleassignments", "microsoft.billing/billingroledefinitions", "microsoft.billing/createbillingroleassignment", "microsoft.billing/enrollmentaccounts", "microsoft.billing/departments", "microsoft.billing/invoices", "microsoft.billing/operationresults", "microsoft.billing/operations", "microsoft.billing/operationstatus", "microsoft.billing/paymentmethods", "microsoft.billing/permissionrequests", "microsoft.billing/promotionalcredits", "microsoft.billing/promotions", "microsoft.billing/transfers", "microsoft.billing/promotions/checkeligibility", "microsoft.billing/transfers/accepttransfer", "microsoft.billing/transfers/declinetransfer", "microsoft.billing/transfers/operationstatus", "microsoft.billing/transfers/validatetransfer", "microsoft.billing/validateaddress", "microsoft.billingbenefits/calculatemigrationcost", "microsoft.billingbenefits/operationresults", "microsoft.billingbenefits/operations", "microsoft.billingbenefits/savingsplanorderaliases", "microsoft.billingbenefits/savingsplanorders", "microsoft.billingbenefits/savingsplanorders/savingsplans", "microsoft.billingbenefits/savingsplans", "microsoft.billingbenefits/validate", "microsoft.capacity/appliedreservations", "microsoft.capacity/autoquotaincrease", "microsoft.capacity/calculateexchange", "microsoft.capacity/calculateprice", "microsoft.capacity/calculatepurchaseprice", "microsoft.capacity/catalogs", "microsoft.capacity/checkbenefitscopes", "microsoft.capacity/checkpurchasestatus", "microsoft.capacity/checkscopes", "microsoft.capacity/checkoffers", "microsoft.capacity/commercialreservationorders", "microsoft.capacity/exchange", "microsoft.capacity/listbenefits", "microsoft.capacity/listskus", "microsoft.capacity/operationresults", "microsoft.capacity/operations", "microsoft.capacity/ownreservations", "microsoft.capacity/placepurchaseorder", "microsoft.capacity/reservationorders", "microsoft.capacity/reservationorders/availablescopes", "microsoft.capacity/reservationorders/calculaterefund", "microsoft.capacity/reservationorders/merge", "microsoft.capacity/reservationorders/reservations", "microsoft.capacity/reservationorders/reservations/availablescopes", "microsoft.capacity/reservationorders/reservations/revisions", "microsoft.capacity/reservationorders/return", "microsoft.capacity/reservationorders/split", "microsoft.capacity/reservationorders/swap", "microsoft.capacity/reservations", "microsoft.capacity/resourceproviders", "microsoft.capacity/resourceproviders/locations", "microsoft.capacity/resourceproviders/locations/servicelimits", "microsoft.capacity/resourceproviders/locations/servicelimitsrequests", "microsoft.capacity/resources", "microsoft.capacity/validatereservationorder", "microsoft.compute/availabilitysets", "microsoft.compute/capacityreservationgroups", "microsoft.compute/capacityreservationgroups/capacityreservations", "microsoft.compute/cloudservices", "microsoft.compute/cloudservices/networkinterfaces", "microsoft.compute/cloudservices/publicipaddresses", "microsoft.compute/cloudservices/roleinstances", "microsoft.compute/cloudservices/roleinstances/networkinterfaces", "microsoft.compute/cloudservices/roles", "microsoft.compute/diskaccesses", "microsoft.compute/diskaccesses/privateendpointconnections", "microsoft.compute/diskencryptionsets", "microsoft.compute/disks", "microsoft.compute/galleries", "microsoft.compute/galleries/applications", "microsoft.compute/galleries/applications/versions", "microsoft.compute/galleries/images", "microsoft.compute/galleries/images/versions", "microsoft.compute/hostgroups", "microsoft.compute/hostgroups/hosts", "microsoft.compute/images", "microsoft.compute/locations", "microsoft.compute/locations/artifactpublishers", "microsoft.compute/locations/capsoperations", "microsoft.compute/locations/cloudserviceosfamilies", "microsoft.compute/locations/cloudserviceosversions", "microsoft.compute/locations/communitygalleries", "microsoft.compute/locations/csoperations", "microsoft.compute/locations/diagnosticoperations", "microsoft.compute/locations/diagnostics", "microsoft.compute/locations/diskoperations", "microsoft.compute/locations/edgezones", "microsoft.compute/locations/edgezones/publishers", "microsoft.compute/locations/edgezones/vmimages", "microsoft.compute/locations/galleries", "microsoft.compute/locations/loganalytics", "microsoft.compute/locations/operations", "microsoft.compute/locations/publishers", "microsoft.compute/locations/recommendations", "microsoft.compute/locations/runcommands", "microsoft.compute/locations/sharedgalleries", "microsoft.compute/locations/spotevictionrates", "microsoft.compute/locations/spotpricehistory", "microsoft.compute/locations/systeminfo", "microsoft.compute/locations/usages", "microsoft.compute/locations/virtualmachines", "microsoft.compute/locations/virtualmachinescalesets", "microsoft.compute/locations/vmsizes", "microsoft.compute/locations/vsmoperations", "microsoft.compute/operations", "microsoft.compute/proximityplacementgroups", "microsoft.compute/restorepointcollections", "microsoft.compute/restorepointcollections/restorepoints", "microsoft.compute/restorepointcollections/restorepoints/diskrestorepoints", "microsoft.compute/sharedvmextensions", "microsoft.compute/sharedvmextensions/versions", "microsoft.compute/sharedvmimages", "microsoft.compute/sharedvmimages/versions", "microsoft.compute/snapshots", "microsoft.compute/sshpublickeys", "microsoft.compute/virtualmachines", "microsoft.compute/virtualmachines/extensions", "microsoft.compute/virtualmachines/metricdefinitions", "microsoft.compute/virtualmachines/runcommands", "microsoft.compute/virtualmachinescalesets", "microsoft.compute/virtualmachinescalesets/extensions", "microsoft.compute/virtualmachinescalesets/networkinterfaces", "microsoft.compute/virtualmachinescalesets/publicipaddresses", "microsoft.compute/virtualmachinescalesets/virtualmachines", "microsoft.compute/virtualmachinescalesets/virtualmachines/extensions", "microsoft.compute/virtualmachinescalesets/virtualmachines/networkinterfaces", "microsoft.compute/virtualmachinescalesets/virtualmachines/runcommands", "microsoft.consumption/aggregatedcost", "microsoft.consumption/balances", "microsoft.consumption/budgets", "microsoft.consumption/charges", "microsoft.consumption/costtags", "microsoft.consumption/credits", "microsoft.consumption/events", "microsoft.consumption/lots", "microsoft.consumption/forecasts", "microsoft.consumption/marketplaces", "microsoft.consumption/operationresults", "microsoft.consumption/operations", "microsoft.consumption/operationstatus", "microsoft.consumption/pricesheets", "microsoft.consumption/products", "microsoft.consumption/reservationdetails", "microsoft.consumption/reservationrecommendationdetails", "microsoft.consumption/reservationrecommendations", "microsoft.consumption/reservationsummaries", "microsoft.consumption/reservationtransactions", "microsoft.consumption/tags", "microsoft.consumption/tenants", "microsoft.consumption/terms", "microsoft.consumption/usagedetails","microsoft.insights/actiongroups"]
  description = "a list of allowed resources"
}
variable "AllowedResourceTypes_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow resource type requirements"
}

variable "Tag_exception"{
  type    = list(string)
  default = []
  description = "scopes that are not required to follow Tag requirements"
}

#===================================
# Data connections
#===================================
data "azurerm_management_group" "ARS" {
  display_name = "AmericanResidentialServices"
}

#=============================================================================
# Networking
# ----------------------------------------------------------------------------
# Subnets should be associated with a Network Security Group
# Network interfaces should disable IP forwarding
# Network Watcher should be enabled
#=============================================================================

#===================================
#Subnets should be associated with a Network Security Group
#===================================
resource "azurerm_management_group_policy_assignment" "NW_NetworkSecurityGroup_ARS" {
    name = "NW_NetworkSecurityGroup"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}

#===================================
#Network interfaces should disable IP forwarding
#===================================
resource "azurerm_management_group_policy_assignment" "NW_IPForwarding_ARS" {
    name = "NW_IPForwarding"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
resource "azurerm_role_assignment" "assignment-NW_IPForwarding_ARS" {
  scope                = azurerm_management_group_policy_assignment.NW_IPForwarding_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.NW_IPForwarding_ARS.identity[0].principal_id
}
#===================================
#Network Watcher should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "NW_NetworkWatcher_ARS" {
    name = "NW_NetworkWatcher"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b6e2945c-0b7b-40f5-9233-7a5323b5cdc6"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#=============================================================================
# Databases
# ----------------------------------------------------------------------------
# Configure Azure SQL database servers diagnostic settings to Log Analytics workspace
# Deploy SQL DB transparent data encryption
#Configure SQL servers to have auditing enabled to Log Analytics workspace 
#Enforce SSL connection should be enabled for MySQL database servers
#Enforce SSL connection should be enabled for PostgreSQL database servers
#An Azure Active Directory administrator should be provisioned for SQL servers
#=============================================================================

#===================================
#Configure Azure SQL database servers diagnostic settings to Log Analytics workspace
#===================================
resource "azurerm_management_group_policy_assignment" "DB_DiagnosticSettings_ARS" {
    name = "DB_DiagnosticSettings"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7ea8a143-05e3-4553-abfe-f56bef8b0b70"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = jsonencode({
          "logAnalyticsWorkspaceId": {
            "value": local.logAnalyticsWorkspaceId
          },
  })
}
resource "azurerm_role_assignment" "assignment-DB_DiagnosticSettings_ARS" {
  scope                = azurerm_management_group_policy_assignment.DB_DiagnosticSettings_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.DB_DiagnosticSettings_ARS.identity[0].principal_id
}
#===================================
#Deploy SQL DB transparent data encryption
#===================================
resource "azurerm_management_group_policy_assignment" "DB_Encryption_ARS" {
    name = "DB_Encryption"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
resource "azurerm_role_assignment" "assignment-DB_Encryption_ARS" {
  scope                = azurerm_management_group_policy_assignment.DB_Encryption_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.DB_Encryption_ARS.identity[0].principal_id
}
#===================================
#Configure SQL servers to have auditing enabled to Log Analytics workspace 
#===================================
resource "azurerm_management_group_policy_assignment" "DB_Auditing_ARS" {
    name = "DB_Auditing"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/25da7dfb-0666-4a15-a8f5-402127efd8bb"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = jsonencode({
          "logAnalyticsWorkspaceId": {
            "value": local.logAnalyticsWorkspaceId
          },
  })
 
}
resource "azurerm_role_assignment" "assignment-DB_Auditing_ARS" {
  scope                = azurerm_management_group_policy_assignment.DB_Auditing_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.DB_Auditing_ARS.identity[0].principal_id
}

#===================================
#Enforce SSL connection should be enabled for MySQL database servers
#===================================
resource "azurerm_management_group_policy_assignment" "DB_MySqlSSL_ARS" {
    name = "DB_MySqlSSL"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e802a67a-daf5-4436-9ea6-f6d821dd0c5d"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}


#===================================
#Enforce SSL connection should be enabled for PostgreSQL database servers
#===================================
resource "azurerm_management_group_policy_assignment" "DB_PostgreSSL_ARS" {
    name = "DB_PostgreSSL"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d158790f-bfb0-486c-8631-2dc6b4e8e6af"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}


#===================================
#An Azure Active Directory administrator should be provisioned for SQL servers
#===================================
resource "azurerm_management_group_policy_assignment" "DB_ADAdministrator_ARS" {
    name = "DB_ADAdministrator"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1f314764-cb73-4fc9-b863-8eca98ac36e9"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}

#=============================================================================
# Storage Accounts
# ----------------------------------------------------------------------------
# Secure transfer to storage accounts should be enabled
#[Preview]: Storage account public access should be disallowed
#Storage accounts should allow access from trusted Microsoft services
#=============================================================================

#===================================
#Secure transfer to storage accounts should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "SA_Https_ARS" {
    name = "SA_Https"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
resource "azurerm_role_assignment" "assignment-SA_HTTPS_ARS" {
  scope                = azurerm_management_group_policy_assignment.SA_Https_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.SA_Https_ARS.identity[0].principal_id
}
#===================================
#[Preview]: Storage account public access should be disallowed
#===================================
resource "azurerm_management_group_policy_assignment" "SA_NoPublicAccess_ARS" {
    name = "SA_NoPublicAccess"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
    enforce = true
    not_scopes = var.sa_publicaccess_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
        parameters = <<PARAMETERS
        {
          "effect": {
            "value": "deny"
          }
        }
        PARAMETERS
}

#===================================
#Storage accounts should allow access from trusted Microsoft services
#===================================
resource "azurerm_management_group_policy_assignment" "SA_TrustMsftServices_ARS" {
    name = "SA_TrustMsftServices"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c9d007d0-c057-4772-b18c-01e546713bcd"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location 
}
#===================================
# Storage accounts should have the specified minimum TLS version
#===================================
resource "azurerm_management_group_policy_assignment" "SA_MinTLS_ARS" {
    name = "SA_MinTLS"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location 
}
#=============================================================================
# VM
# ----------------------------------------------------------------------------
# Network interfaces should not have public Ips
# Allowed virtual machine size SKUs
#=============================================================================
#===================================
# Network interfaces should not have public Ips
#===================================
resource "azurerm_management_group_policy_assignment" "VM_PublicIP_ARS" {
    name = "VM_PublicIP"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
    enforce = true
    not_scopes = var.Vm_PublicIP_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
resource "azurerm_role_assignment" "assignment-VM_PublicIP_ARS" {
  scope                = azurerm_management_group_policy_assignment.VM_PublicIP_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.VM_PublicIP_ARS.identity[0].principal_id
}
#===================================
# VM Sku's
#===================================

resource "azurerm_management_group_policy_assignment" "VM_SKUs_ARS" {
    name = "VM_SKU"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
    enforce = true
    not_scopes = var.VmSKU_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters =  <<PARAMETERS
        {
          "listOfAllowedSKUs": {
            "value": ["standard_a1_v2","standard_a2_v2","standard_a2m_v2","standard_a4_v2","standard_a4m_v2","standard_a8_v2","standard_a8m_v2","standard_b12ms","standard_b16ms","standard_b1ms","standard_b2ms","standard_b4ms","standard_b8ms","standard_f16s_v2","standard_f2s_v2","standard_f4s_v2","standard_f8s_v2","standard_d16ds_v4","standard_d2ds_v4","standard_d4ds_v4","standard_d8ds_v4","standard_d16ds_v5","standard_d2ds_v5","standard_d4ds_v5","standard_d8ds_v5","standard_e16ds_v4","standard_e2ds_v4","standard_e4ds_v4","standard_e8ds_v4","standard_e16ds_v5","standard_e2ds_v5","standard_e4ds_v5","standard_e8ds_v5"]
          }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-VM_SKUs_ARS" {
  scope                = azurerm_management_group_policy_assignment.VM_SKUs_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.VM_SKUs_ARS.identity[0].principal_id
}

#=============================================================================
# Key Vault
# ----------------------------------------------------------------------------
# Resource logs in Key Vault should be enabled
# Key vaults should have purge protection enabled
#=============================================================================
#===================================
# Resource logs in Key Vault should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "KV_ResourceLogs_ARS" {
    name = "KV_ResourceLogs"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cf820ca0-f99e-4f3e-84fb-66e913812d21"
    enforce = true
    not_scopes = var.VmSKU_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}

#===================================
# Key vaults should have purge protection enabled
#===================================
resource "azurerm_management_group_policy_assignment" "KV_PurgeProtection_ARS" {
    name = "KV_PurgeProtection"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
    enforce = true
    not_scopes = var.VmSKU_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
resource "azurerm_role_assignment" "assignment-KV_PurgeProtection_ARS" {
  scope                = azurerm_management_group_policy_assignment.KV_PurgeProtection_ARS.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.KV_PurgeProtection_ARS.identity[0].principal_id
}

#=============================================================================
# Governance
# ----------------------------------------------------------------------------
# Allowed Locations
# Allowed locations for resource groups
# Configure Azure Activity logs to stream to specified Log Analytics workspace
# Auto provisioning of the Log Analytics agent should be enabled on your subscription
# Subscriptions should have a contact email address for security issues
# Email notification for high severity alerts should be enabled
# Allowed resource types
# Require a Tag on Resources 
# Require a tag on resource groups
# Inherit a tag from the resource group if missing 
#An activity log alert should exist for specific Policy operations 
#An activity log alert should exist for specific Administrative operations 
#An activity log alert should exist for specific Security operations 
#=============================================================================
#===================================
# Allowed Locations
#===================================    
resource "azurerm_management_group_policy_assignment" "AllowedLocation_ARS" {
    name = "AllowedLocations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    not_scopes = var.location_exception
    parameters = jsonencode({
          "listOfAllowedLocations": {
            "value": var.allowedlocations
          },
  })
}


#===================================
# Allowed Locations for Resource Groups
#===================================    
resource "azurerm_management_group_policy_assignment" "RGAllowedLocation_ARS" {
    name = "RGAllowedLocations"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    enforce = true
    not_scopes = var.location_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters =  jsonencode({
          "listOfAllowedLocations": {
            "value": var.allowedlocations
          },
  })
}


#===================================
# Configure Azure Activity logs to stream to specified Log Analytics workspace
#===================================    
resource "azurerm_management_group_policy_assignment" "LogActivity_ARS" {
    name = "LogActivity"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = jsonencode({
        "logAnalytics": {
            "value": local.logAnalyticsWorkspaceId
        }
  })
}
#If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.
resource "azurerm_role_assignment" "assignment-LogActivity_ARS" {
  scope                = azurerm_management_group_policy_assignment.LogActivity_ARS.management_group_id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.LogActivity_ARS.identity[0].principal_id
}
#===================================
#Auto provisioning of the Log Analytics agent should be enabled on your subscription
#===================================
resource "azurerm_management_group_policy_assignment" "SubLogAnalytics_ARS" {
    name = "SubLogAnalytics"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/475aae12-b88a-4572-8b36-9b712b2b3a17"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}

#===================================
#Subscriptions should have a contact email address for security issues
#===================================
resource "azurerm_management_group_policy_assignment" "SubEmail_ARS" {
    name = "SubEmail"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}

#===================================
# Email notification for high severity alerts should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "Alerts_ARS" {
    name = "Alerts"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6e2593d9-add6-4083-9c9b-4b7d2188c899"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters =  <<PARAMETERS
        {
          "effect": {
            "value": "AuditIfNotExists"
          }
        }
        PARAMETERS
}

#===================================
# Allowed resource types
#===================================
resource "azurerm_management_group_policy_assignment" "AllowedResources_ARS" {
    name = "AllowedResources"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    not_scopes = var.AllowedResourceTypes_exception
    parameters =  jsonencode({
      "listOfResourceTypesAllowed": {
        "value": var.AllowedResourceTypes,
      },
    })
}



#===================================
# Require a Tag on Resources 
#===================================

# System Tag
resource "azurerm_management_group_policy_assignment" "Tag_System" {
    name = "Tag_System"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "System"
            }
        }
        PARAMETERS
}
# Environment Tag
resource "azurerm_management_group_policy_assignment" "Tag_Environment" {
    name = "Tag_Environment"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "Environment"
            }
        }
        PARAMETERS
}
# CostCenter Tag
resource "azurerm_management_group_policy_assignment" "Tag_CostCenter" {
    name = "Tag_CostCenter"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "CostCenter"
            }
        }
        PARAMETERS
}
# Classification Tag
resource "azurerm_management_group_policy_assignment" "Tag_Classification" {
    name = "Tag_Classification"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "Classification"
            }
        }
        PARAMETERS
}
# LastUpdated Tag
resource "azurerm_management_group_policy_assignment" "Tag_LastUpdated" {
    name = "Tag_LastUpdated"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "LastUpdated"
            }
        }
        PARAMETERS
}

#===================================
#Require a tag on resource groups
#===================================
# BusinessImpact Tag
resource "azurerm_management_group_policy_assignment" "Tag_BusinessImpact" {
    name = "Tag_BusinessImpact"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessImpact"
            }
        }
        PARAMETERS
}
# BusinessOwner Tag
resource "azurerm_management_group_policy_assignment" "Tag_BusinessOwner" {
    name = "Tag_BusinessOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessOwner"
            }
        }
        PARAMETERS
}
# TechnicalOwner Tag
resource "azurerm_management_group_policy_assignment" "Tag_TechnicalOwner" {
    name = "Tag_TechnicalOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "TechnicalOwner"
            }
        }
        PARAMETERS
}

#===================================
# Inherit a tag from the resource group if missing 
#===================================
resource "azurerm_management_group_policy_assignment" "TagI_BusinessImpact" {
    name = "TagI_BusinessImpact"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessImpact"
            }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-TagI_BusinessImpact_ARS" {
  scope                = azurerm_management_group_policy_assignment.TagI_BusinessImpact.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.TagI_BusinessImpact.identity[0].principal_id
}

resource "azurerm_management_group_policy_assignment" "TagI_BusinessOwner" {
    name = "TagI_BusinessOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "BusinessOwner"
            }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-TagI_BusinessOwner_ARS" {
  scope                = azurerm_management_group_policy_assignment.TagI_BusinessOwner.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.TagI_BusinessOwner.identity[0].principal_id
}

resource "azurerm_management_group_policy_assignment" "TagI_TechnicalOwner" {
    name = "TagI_TechnicalOwner"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    enforce = true
    not_scopes = var.Tag_exception
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
        {
            "tagName": {
                "value": "TechnicalOwner"
            }
        }
        PARAMETERS
}
resource "azurerm_role_assignment" "assignment-TagI_TechnicalOwner_ARS" {
  scope                = azurerm_management_group_policy_assignment.TagI_TechnicalOwner.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.TagI_TechnicalOwner.identity[0].principal_id
}
#===================================
#An activity log alert should exist for specific Policy operations
# "Microsoft.Authorization/policyAssignments/write",
# "Microsoft.Authorization/policyAssignments/delete"
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_PolicyOps1" {
    name = "Alert_PolicyOps1"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Authorization/policyAssignments/write" 
      }
    }
    PARAMETERS
}
resource "azurerm_management_group_policy_assignment" "Alert_PolicyOps2" {
    name = "Alert_PolicyOps2"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c5447c04-a4d7-4ba8-a263-c9ee321a6858"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Authorization/policyAssignments/delete" 
      }
    }
    PARAMETERS
}
#===================================
#An activity log alert should exist for specific Administrative operations 
# "Microsoft.Sql/servers/firewallRules/write"
# "Microsoft.Sql/servers/firewallRules/delete",
# "Microsoft.Network/networkSecurityGroups/write",
# "Microsoft.Network/networkSecurityGroups/delete", 
# "Microsoft.Network/networkSecurityGroups/securityRules/write",
# "Microsoft.Network/networkSecurityGroups/securityRules/delete",
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_AdminOps1" {
    name = "Alert_AdminOps1"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Sql/servers/firewallRules/write"
      }
    }
    PARAMETERS
}
resource "azurerm_management_group_policy_assignment" "Alert_AdminOpns2" {
    name = "Alert_AdminOps2"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Sql/servers/firewallRules/delete"
      }
    }
    PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "Alert_AdminOps3" {
    name = "Alert_AdminOps3"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Network/networkSecurityGroups/write"
      }
    }
    PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "Alert_AdminOps4" {
    name = "Alert_AdminOps4"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Network/networkSecurityGroups/delete"
      }
    }
    PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "Alert_AdminOps5" {
    name = "Alert_AdminOps5"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Network/networkSecurityGroups/securityRules/write"
      }
    }
    PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "Alert_AdminOps6" {
    name = "Alert_AdminOps6"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b954148f-4c11-4c38-8221-be76711e194a"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Network/networkSecurityGroups/securityRules/delete"
      }
    }
    PARAMETERS
}


#===================================
#An activity log alert should exist for specific Security operations 
# "Microsoft.Security/policies/write",
# "Microsoft.Security/securitySolutions/write",
# "Microsoft.Security/securitySolutions/delete"
#===================================

resource "azurerm_management_group_policy_assignment" "Alert_SecurityOps1" {
    name = "Alert_SecurityOps1"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Security/policies/write" 
      }
    }
    PARAMETERS
}
resource "azurerm_management_group_policy_assignment" "Alert_SecurityOps2" {
    name = "Alert_SecurityOps2"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Security/securitySolutions/write" 
      }
    }
    PARAMETERS
}
resource "azurerm_management_group_policy_assignment" "Alert_SecurityOps3" {
    name = "Alert_SecurityOps3"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3b980d31-7904-4bb7-8575-5665739a8052"
    enforce = true
    identity {
        type = "SystemAssigned"
    }
    location = local.location
    parameters = <<PARAMETERS
    {
     "operationName": {
        "value": "Microsoft.Security/securitySolutions/delete"
      }
    }
    PARAMETERS
}
#=============================================================================
# Identity and Access Management
# ----------------------------------------------------------------------------
# MFA should be enabled on accounts with owner permissions on your subscription
# External accounts with owner permissions should be removed from your subscription
#=============================================================================

#===================================
# MFA should be enabled on accounts with owner permissions on your subscription 
#===================================
resource "azurerm_management_group_policy_assignment" "IAM_MFA_ARS" {
    name = "IAM_MFA"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/aa633080-8b72-40c4-a2d7-d00c03e80bed"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}

#===================================
# External accounts with owner permissions should be removed from your subscription 
#===================================
resource "azurerm_management_group_policy_assignment" "IAM_RemoveExternalAccounts_ARS" {
    name = "IAM_RmExternalAccounts"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f8456c1c-aa66-4dfb-861a-25d127b775c9"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}


#=============================================================================
# Azure Defender
# ----------------------------------------------------------------------------
# Azure Defender for App Service should be enabled
# Azure Defender for Azure SQL Database servers should be enabled
# Azure Defender for Key Vault should be enabled
# Azure Defender for servers should be enabled
# Azure Defender for Storage should be enabled
# Azure Kubernetes Service clusters should have Defender profile enabled
# Microsoft Defender for Containers should be enabled
#=============================================================================

#===================================
# Azure Defender for App Service should be enabled 
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_AppService_ARS" {
    name = "DEF_AppService"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/2913021d-f2fd-4f3d-b958-22354e2bdbcb"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Azure Defender for Azure SQL Database servers should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_SQL_ARS" {
    name = "DEF_SQL"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7fe3b40f-802b-4cdd-8bd4-fd799c948cc2"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Azure Defender for Key Vault should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_KeyVault_ARS" {
    name = "DEF_KeyVault"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0e6763cc-5078-4e64-889d-ff4d9a839047"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Azure Defender for servers should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_VM_ARS" {
    name = "DEF_VM"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4da35fc9-c9e7-4960-aec9-797fe7d9051d"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Azure Defender for Storage should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_Storage_ARS" {
    name = "DEF_Storage"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/308fbb08-4ab8-4e67-9b29-592e93fb94fa"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Azure Kubernetes Service clusters should have Defender profile enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_Kubernetes_ARS" {
    name = "DEF_Kubernetes"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a1840de2-8088-4ea8-b153-b4c723e9cb01"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
#===================================
# Microsoft Defender for Containers should be enabled
#===================================
resource "azurerm_management_group_policy_assignment" "DEF_Containers_ARS" {
    name = "DEF_Containers"
    management_group_id = data.azurerm_management_group.ARS.id
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c988dd6-ade4-430f-a608-2a3e5b0a6d38"
    enforce = true
    not_scopes = []
    identity {
        type = "SystemAssigned"
    }
    location = local.location
}
