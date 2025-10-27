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

const path_witcher_game = process.env.WITCHER_ROOT;

require.main == module && main();
module.exports = main;

function main() {
  script_compile();
  removeCurrentWorkspaceScripts();
  copyCompiledScriptsToWorkspace();

  if (process.argv.includes("--game")) {
    copyWorkspaceScriptsToGame();
  }
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

function copyWorkspaceScriptsToGame() {
  const path_witcher_game_local_scripts = path.join(
    path_witcher_game,
    "mods",
    "modwild_monster_hunt",
    "content",
    "scripts",
    "local"
  );

  fs.rmSync(path_witcher_game_local_scripts, { recursive: true });
  fs.cpSync(path_workspace_scripts, path_witcher_game_local_scripts, {
    recursive: true,
  });
}
