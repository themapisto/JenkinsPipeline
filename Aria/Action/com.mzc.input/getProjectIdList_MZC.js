if (except === undefined || except == null || except == "") { except = []; }
else { except = except.split(/,\s*/); }
if (search === undefined || search == null || search == "") { search = null; }
else { search = search.toLowerCase(); }

var vra = System.getModule("com.mzc").VraManager();

var result = [];
for each(var content in vra.get("/iaas/api/projects").content) {
    if (except.indexOf(content.name) < 0) {
        if (search) {
            if (content.name.toLowerCase().indexOf(search) > -1) { result.push({label: content.name, value: content.id}); }
        } else { result.push({label: content.name, value: content.id}); }
    }
}


System.log(result)
System.log("obj: " + JSON.stringify(result));

return result.sort(function (a, b) { return a.label.localeCompare(b.label)});