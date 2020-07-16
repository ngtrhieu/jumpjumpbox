using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.AddressableAssets.ResourceLocators;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceLocations;
using UnityEngine.ResourceManagement.ResourceProviders;

namespace Autumn.Addressables {
  ///<sumamry>
  /// Prvider for asset bundles from S3 storage.
  ///</summary>
  [DisplayName("S3 AssetBundle Provider")]
  public class S3BundleProvider : AssetBundleProvider {

    public readonly Dictionary<string, AsyncOperationHandle<IAssetBundleResource>> bundleOperationHandlers = new Dictionary<string, AsyncOperationHandle<IAssetBundleResource>>();

    public override void Provide(ProvideHandle provideHandle) {
      Debug.Log($"provideHandle.Location: {provideHandle.Location}");

      var resourceIdentifier = UnityEngine.AddressableAssets.Addressables.ResourceManager.TransformInternalId(provideHandle.Location);

      Debug.Log($"Loading S3 bundle at: {resourceIdentifier}");
      provideHandle.Complete(default(object), false, null);

      base.Provide(provideHandle);
    }

    public override void Release(IResourceLocation location, object asset) {
      base.Release(location, asset);

      if (bundleOperationHandlers.TryGetValue(location.InternalId, out var operation)) {
        if (operation.IsValid()) {
          UnityEngine.AddressableAssets.Addressables.ResourceManager.Release(operation);
        }
        bundleOperationHandlers.Remove(location.InternalId);
      }
    }
  }
}