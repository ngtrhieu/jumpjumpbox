const path = require("path");
const fs = require("fs");
const { parse, stringify } = require("./helpers/unity_yaml");

if (!process.env.PROJECT_PATH) {
  console.error("PROJECT_PATH is not set.");
  process.exit(1);
}
// Read the content of ProjectSettings
const yaml = parse(
  fs.readFileSync(
    path.join(
      process.env.PROJECT_PATH,
      "/Assets/AddressableAssetsData/AddressableAssetSettings.asset"
    ),
    {
      encoding: "utf8",
    }
  )
);
const addressableAssetSettings = yaml.documents[Object.keys(yaml.documents)[0]];

// Find the profile settings for CI
const ciProfile = addressableAssetSettings.MonoBehaviour.m_ProfileSettings.m_Profiles.filter(
  (profile) => profile.m_ProfileName === "CI"
)[0];

// Find the profile variable name for RemoteLoadPath
const remoteLoadPathVar = addressableAssetSettings.MonoBehaviour.m_ProfileSettings.m_ProfileEntryNames.filter(
  (profile) => profile.m_Name === "RemoteLoadPath"
)[0];

// Retrieve the RemoteLoadPath variable inside ciProfile
const remoteLoadPath = ciProfile.m_Values.filter(
  (variable) => variable.m_Id === remoteLoadPathVar.m_Id
)[0];
remoteLoadPath.m_Value =
  process.env.ADDRESSABLE_REMOTE_LOAD_PATH || remoteLoadPath.m_Value;

fs.writeFileSync(
  path.join(
    process.env.PROJECT_PATH,
    "/Assets/AddressableAssetsData/AddressableAssetSettings.asset"
  ),
  stringify(yaml),
  {
    encoding: "utf8",
  }
);
