// inputs
// except string
// search string
// zoneId string
// networkTag string

if (zoneId === undefined || zoneId == null || zoneId == "") { return []; }
if (networkTag === undefined || networkTag == null || networkTag == "") { return []; }
var tagUrl = "/provisioning/mgmt/tags?$filter=";
if (networkTag.indexOf(":") > -1) {
    var tag = networkTag.split(":");
    tagUrl += "((key eq '" + tag[0] + "') and (value eq '" + tag[1] + "'))";
} else {
    tagUrl += "(key eq '" + networkTag + "')"
}

System.log(tagUrl);

var vra=System.getModule("com.mzc").VraManager();
var ip= System.getModule("com.mzc").Converter().ip;

var netProfs= vra.getUerp("/provisioning/mgmt/network-profile?expand&$filter=(placementZoneLink eq '/provisioning/resources/placement-zones/" + zoneId + "')");

if (netProfs.totalCount == 0) {
    netProfs = vra.getUerp("/provisioning/mgmt/network-profile?expand&$filter=(provisioningRegionLink eq '" + vra.getUerp("/provisioning/resources/placement-zones/" + zoneId).provisioningRegionLink + "')");
    if (netProfs.totalCount == 0) {
        throw "Error : could not find network profile";
    }
}
var zoneSubnetLinks = [];
for each(var netProf in netProfs.documents) {
    zoneSubnetLinks = zoneSubnetLinks.concat(netProf.subnetLinks);
}

var subnetLinks = [];
for each(var tagLink in vra.getUerp(tagUrl).documentLinks) {
    for each(var subnetLink in vra.getUerp("/provisioning/mgmt/tag-usage?tagLinks=" + tagLink).documentLinks) {
        if (zoneSubnetLinks.indexOf(subnetLink) > -1) {
            subnetLinks.push(subnetLink);
        }
    }
}
if (subnetLinks.length != 1) { return []; }
var subnetLink = subnetLinks[0];
var unAvailable = [];
var ipNums = []

for each(var subnetRange in vra.getUerp("/resources/subnet-ranges?expand").documents) {
    if (subnetRange.subnetLinks.indexOf(subnetLink) > -1) {
        var subnetRangeLink = subnetRange.documentSelfLink;
        for each(var ipAddress in vra.getUerp("/resources/ip-addresses?expand&$filter=((subnetRangeLink eq '" + subnetRangeLink + "') and (ipAddressStatus ne 'AVAILABLE'))").documents) {
            unAvailable.push(ip.getNumeric(ipAddress.ipAddress));
        }
        var ipNum = ip.getNumeric(subnetRange.startIPAddress);
        var ipEnd = ip.getNumeric(subnetRange.endIPAddress);
        for (; ipNum <= ipEnd; ipNum++) {
            if (unAvailable.indexOf(ipNum) < 0) {
                ipNums.push(ipNum);
            }
        }
    }
}

var result = [];
for each(var ipNum in ipNums.sort()) {
    var content = ip.getString(ipNum);
    if (except.indexOf(content) < 0) {
        if (search) {
            if (content.indexOf(search) > -1) { result.push(content); }
        } else { result.push(content); }
    }
}

for(var i = 0; i < result.length; i++) {
    System.log(result[i] + '<br>');
}
return result;