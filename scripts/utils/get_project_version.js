const path = require("path");
const fs = require("fs");
const { parse } = require("./helpers/unity_yaml");

if (!process.env.PROJECT_PATH) {
  console.error("PROJECT_PATH is not set.");
  process.exit(1);
}
// Read the content of ProjectSettings
const yaml = parse(
  fs.readFileSync(
    path.join(
      process.env.PROJECT_PATH,
      "/ProjectSettings/ProjectSettings.asset"
    ),
    {
      encoding: "utf8",
    }
  )
);

const projectSettings = yaml.documents[Object.keys(yaml.documents)[0]];

// Print back bundleVersion to console
console.log(projectSettings.PlayerSettings.bundleVersion);
