const path = require("path");
const fs = require("fs");
const YAML = require("yaml");

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
