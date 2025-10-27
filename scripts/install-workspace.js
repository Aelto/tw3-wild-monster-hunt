const fs = require("fs");
const path = require("path");

const script_compile = require("./compile.js");

const path_mod = path.join(__dirname, "..");
const path_workspace = path.join(
  path_mod,
  "redkit",
  "wild_monster_hunt",
  "workspace"
);
const path_workspace_scripts = path.join(path_workspace, "scripts", "local");
const path_compiled_scripts = path.join(
  path_mod,
  "dist",
  "modwild_monster_hunt",
  "content",
  "scripts",
  "local"
);

require.main == module && main();
module.exports = main;

function main() {
  script_compile();
  removeCurrentWorkspaceScripts();
  copyCompiledScriptsToWorkspace();
}

function removeCurrentWorkspaceScripts() {
  console.log(`removing workspace scripts at ${path_workspace_scripts}`);
  fs.rmSync(path.join(path_workspace_scripts, "wmhwss"), {
    recursive: true,
    force: true,
  });
}

function copyCompiledScriptsToWorkspace() {
  fs.cpSync(path_compiled_scripts, path_workspace_scripts, { recursive: true });
}
