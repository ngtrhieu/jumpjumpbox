using System;
using System.Collections;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings;
using UnityEngine;

static class BuildContentCommand {

  static string GetArgument(string name) {
    string[] args = Environment.GetCommandLineArgs();
    for (int i = 0; i < args.Length; i++) {
      if (args[i].Contains(name)) {
        return args[i + 1];
      }
    }
    return null;
  }

  private static void CleanPlayerContent() {
    Console.WriteLine(":: Clean player content");
    var activeBuilder = AddressableAssetSettingsDefaultObject.Settings.ActivePlayerDataBuilder;
    AddressableAssetSettings.CleanPlayerContent(activeBuilder);
    Console.WriteLine(":: Done cleaning player content");
  }

  private static void SetActiveProfile(string profileName) {
    Console.WriteLine(":: Setting active profile to {0}", profileName);

    var addressableAssetSettings = AddressableAssetSettingsDefaultObject.Settings;

    var profileNames = addressableAssetSettings.profileSettings.GetAllProfileNames();
    for (var i = 0; i < profileNames.Count; ++i) {
      Debug.Log(profileNames[i]);
    }

    // Check that the profile name exists
    if (!addressableAssetSettings.profileSettings.GetAllProfileNames().Contains(profileName)) {
      throw new Exception(string.Format("Profile {0} not found", profileName));
    }

    var profileId = addressableAssetSettings.profileSettings.GetProfileId(profileName);
    if (addressableAssetSettings.activeProfileId != profileId) {
      addressableAssetSettings.activeProfileId = profileId;
      EditorUtility.SetDirty(AddressableAssetSettingsDefaultObject.Settings);
    }

    Console.WriteLine(":: Done setting active profile to {0}", profileName);
  }

  public static void PerformBuild() {
    Console.WriteLine(":: Prebuild player content");
    CleanPlayerContent();

    var profileName = GetArgument("addressableProfile");
    SetActiveProfile(profileName);
    Console.WriteLine(":: Done prebuild player content");

    Console.WriteLine(":: Build player content");
    AddressableAssetSettings.BuildPlayerContent();
    Console.WriteLine(":: Done building player content");
  }
}