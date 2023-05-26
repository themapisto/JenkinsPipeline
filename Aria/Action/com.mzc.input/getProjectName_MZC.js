if (projectId === undefined || projectId == null || projectId == "") { return ""; }

var vra = System.getModule("com.mzc").VraManager();
var project = vra.get("/iaas/api/projects/" + projectId);
return project.name;