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

  if (process.argv.includes("--release")) {
    copyWorkspaceScriptsToRelease();
  }
}

function removeCurrentWorkspaceScripts() {
  console.log(`removing WORKSPACE scripts at ${path_workspace_scripts}`);
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

  console.log(`updating GAME scripts at ${path_witcher_game_local_scripts}`);
  fs.rmSync(path_witcher_game_local_scripts, { recursive: true });
  fs.cpSync(path_workspace_scripts, path_witcher_game_local_scripts, {
    recursive: true,
  });
}

function copyWorkspaceScriptsToRelease() {
  const path_release_local_scripts = path.join(
    path_mod,
    "release",
    "mods",
    "modwild_monster_hunt",
    "content",
    "scripts",
    "local"
  );

  console.log(`updating RELEASE scripts at ${path_release_local_scripts}`);
  fs.rmSync(path_release_local_scripts, { recursive: true });
  fs.cpSync(path_workspace_scripts, path_release_local_scripts, {
    recursive: true,
  });
}
