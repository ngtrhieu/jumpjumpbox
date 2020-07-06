using System;
using System.Collections;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings;
using UnityEngine;

static class BuildContentCommand {

  private const string ADDRESSABLE_PROFILE = "ADDRESSABLE_PROFILE";

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

    // Check that the profile name exists
    if (!addressableAssetSettings.profileSettings.GetAllProfileNames().Contains(profileName)) {
      throw new Exception(string.Format("Profile {0} not found", profileName));
    }

    if (addressableAssetSettings.activeProfileId != profileName) {
      addressableAssetSettings.activeProfileId = profileName;
      EditorUtility.SetDirty(AddressableAssetSettingsDefaultObject.Settings);
    }

    Console.WriteLine(":: Done setting active profile to {0}", profileName);
  }

  public static void PerformBuild() {
    Console.WriteLine(":: Prebuild player content");
    CleanPlayerContent();

    var profileName = GetArgument(ADDRESSABLE_PROFILE);
    SetActiveProfile(profileName);
    Console.WriteLine(":: DOne prebuild player content");

    Console.WriteLine(":: Build player content");
    AddressableAssetSettings.BuildPlayerContent();
    Console.WriteLine(":: Done building player content");
  }
}