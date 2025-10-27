const { execSync } = require("child_process");
const { cpSync } = require("fs");
const { join } = require("path");

const path_mod = join(__dirname, "..");
const path_dist = join(path_mod, "dist");
const path_src = join(path_mod, "src");
const path_src_local = join(
  path_src,
  "modwild_monster_hunt",
  "content",
  "scripts",
  "local"
);

require.main == module && main();
module.exports = main;

function main() {
  console.log(`compiling scripts`);
  console.log(execSync("cahirc ..", { encoding: "utf-8" }));

  const path_local_annotations = join(path_src_local, "wmhannotations");
  const path_dist_annotations = join(
    path_dist,
    "modwild_monster_hunt",
    "content",
    "scripts",
    "local",
    "wmhannotations"
  );

  console.log(`copying annotations to dist`);
  cpSync(path_local_annotations, path_dist_annotations, { recursive: true });
}
