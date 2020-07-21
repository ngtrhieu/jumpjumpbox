using UnityEngine;

public class AddS3BundleProvider : MonoBehaviour {
  void Awake() {

    Debug.Log("Add S3BundleProvider");
    UnityEngine.AddressableAssets.Addressables.ResourceManager.ResourceProviders.Add(new Autumn.Addressables.S3BundleProvider());

  }
}
