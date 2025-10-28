const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const STRINGS_ID = 9426;

const path_mod = path.join(__dirname, "..");
const path_release = path.join(path_mod, "release");
const path_redkit_packed = path.join(
  path_mod,
  "redkit",
  "wild_monster_hunt",
  "packed"
);

const path_release_dlc_wmh = path.join(
  path_release,
  "dlc",
  "dlcwild_monster_hunt"
);

require.main == module && main();

module.exports = main;

function main() {
  if (!process.argv.includes("--no-reset")) {
    resetReleaseFolder();
    moveRedkitPackedToRelease();
  }

  copyStringsCsvToDlc();
  encodeDlcStringsCsv();

  duplicateStringsToAllLanguages(
    path.join(
      path_release,
      "mods",
      "modwild_monster_hunt",
      "content",
      "en.w3strings"
    )
  );

  duplicateStringsToAllLanguages(
    path.join(path_release_dlc_wmh, "content", "en.w3strings")
  );

  copyDependencies();
}

function resetReleaseFolder() {
  fs.rmSync(path_release, { recursive: true, force: true });
  fs.mkdirSync(path_release, { recursive: true });
}

function moveRedkitPackedToRelease() {
  const moveSubFolder = (sub) =>
    fs.renameSync(
      path.join(path_redkit_packed, sub),
      path.join(path_release, sub)
    );

  moveSubFolder("dlc");
  moveSubFolder("mods");
}

function duplicateStringsToAllLanguages(path_en_w3strings) {
  const path_origin = path.dirname(path_en_w3strings);

  const languages = [
    "ar",
    "br",
    "cz",
    "de",
    "es",
    "esmx",
    "fr",
    "hu",
    "it",
    "jp",
    "kr",
    "pl",
    "ru",
    "zh",
    "cn",
  ];

  for (const language of languages) {
    fs.copyFileSync(
      path_en_w3strings,
      path.join(path_origin, `${language}.w3strings`)
    );
  }
}

function copyStringsCsvToDlc() {
  const path_strings_csv = path.join(path_mod, "en.w3strings.csv");
  const path_dlc = path.join(path_release, "dlc", "dlcwild_monster_hunt");
  const path_dlc_csv = path.join(path_dlc, "content", "en.w3strings.csv");

  console.log(`copying ${path_strings_csv} >>> ${path_dlc_csv}`);
  fs.copyFileSync(path_strings_csv, path_dlc_csv);
}

function encodeDlcStringsCsv() {
  const path_release_dlc_wmh_content = path.join(
    path_release_dlc_wmh,
    "content"
  );
  const path_dlc_w3strings_csv = path.join(
    path_release_dlc_wmh_content,
    "en.w3strings.csv"
  );
  const path_dlc_w3strings = path.join(
    path_release_dlc_wmh_content,
    "en.w3strings"
  );

  autogenerateCsvIds();

  // for when the strings encoder will officially support it, it'll replace the
  // autogenerateCsvIds function below.
  const arg_autogen_ids = "--auto-generate-missing-ids";
  const arg_encode = `--encode ${path_dlc_w3strings_csv}`;
  const arg_idspace = `--id-space ${STRINGS_ID}`;
  execSync(`w3strings ${arg_encode} ${arg_idspace}`);
  fs.renameSync(
    path.join(path_release_dlc_wmh_content, "en.w3strings.csv.w3strings"),
    path_dlc_w3strings
  );
  fs.rmSync(
    path.join(path_release_dlc_wmh_content, "en.w3strings.csv.w3strings.ws")
  );

  function autogenerateCsvIds() {
    let id = 2119426001;

    const csv_content = fs.readFileSync(path_dlc_w3strings_csv, "utf-8");
    const csv_content_edited = csv_content.split("\n").map(mapLine).join("\n");
    fs.writeFileSync(path_dlc_w3strings_csv, csv_content_edited, "utf-8");

    /**
     *
     * @param {string} line
     * @returns string
     */
    function mapLine(line) {
      if (line.startsWith("2119426") || line.startsWith("||")) {
        const first_pipe_index = line.indexOf("|");
        const line_without_id = line.slice(first_pipe_index);

        return `${id++}${line_without_id}`;
      }

      return line;
    }
  }
}

function copyDependencies() {
  const dependencies = [
    "mods/mod_sharedutils_damagemodifiers",
    "mods/mod_sharedutils_dialogChoices",
    "mods/mod_sharedutils_glossary",
    "mods/mod_sharedutils_helpers",
    "mods/mod_sharedutils_oneliners",
  ];

  const path_sharedutils_release = path.join(
    path_mod,
    "tw3-shared-utils",
    "release"
  );

  for (const dep of dependencies) {
    const path_dep = path.join(path_sharedutils_release, dep);
    const path_dep_copy = path.join(path_release, dep);

    console.log(`copying ${path_dep} >>> ${path_dep_copy}`);
    fs.cpSync(path_dep, path_dep_copy, { recursive: true });
  }
}
