const path = require("path");
const fs = require("fs");
const YAML = require("yaml");

if (!process.env.PROJECT_PATH) {
  console.error("PROJECT_PATH is not set. Cannot get project version");
  process.exit(1);
}

const SEPARATOR = "\n";

// Read the content of ProjectSettings
const file = fs.readFileSync(
  path.join(process.env.PROJECT_PATH, "/ProjectSettings/ProjectSettings.asset"),
  {
    encoding: "utf8",
  }
);

// Remove the first 3 lines
const lines = file.split(SEPARATOR);
const yaml = lines.slice(3).join(SEPARATOR);

// Parse YAML content
const projectSettings = YAML.parse(yaml);

// Print back bundleVersion to console
console.log(projectSettings.PlayerSettings.bundleVersion);
