using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement;
using UnityEngine.AddressableAssets.ResourceLocators;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceLocations;
using UnityEngine.ResourceManagement.ResourceProviders;

namespace Autumn.Addressables {
  ///<sumamry>
  /// Prvider for asset bundles from S3 storage.
  ///</summary>
  [DisplayName("S3 AssetBundle Provider")]
  public class S3BundleProvider : ResourceProviderBase {

    public override void Provide(ProvideHandle provideHandle) {
      new S3AssetBundleResource().Start(provideHandle);
    }

    public override System.Type GetDefaultType(IResourceLocation location) {
      return typeof(IAssetBundleResource);
    }

    public override void Release(IResourceLocation location, object asset) {
      if (location == null) {
        throw new System.ArgumentNullException("location");
      }

      if (asset == null) {
        Debug.LogWarningFormat("Releasing null asset bundle from location {0}.  This is an indication that the bundle failed to load.", location);
        return;
      }

      var bundle = asset as S3AssetBundleResource;
      if (bundle != null) {
        bundle.Unload();
        return;
      }
    }
  }

  class S3AssetBundleResource : IAssetBundleResource {
    private int retries = 0;
    private AssetBundle assetBundle;
    private DownloadHandlerAssetBundle downloadHandler;
    private ProvideHandle provideHandle;
    private UnityEngine.AsyncOperation asyncOperation;
    private AssetBundleRequestOptions options;

    public float PercentComplete() {
      return asyncOperation != null ? asyncOperation.progress : 0.0f;
    }

    public void Start(ProvideHandle provideHandle) {

      // Setup the resources
      this.retries = 0;
      this.assetBundle = null;
      this.downloadHandler = null;
      this.provideHandle = provideHandle;
      this.options = provideHandle.Location.Data as AssetBundleRequestOptions;
      this.asyncOperation = null;
      provideHandle.SetProgressCallback(PercentComplete);

      // Start the operation
      BeginOperation();
    }

    public void Unload() {
      assetBundle?.Unload(true);
      assetBundle = null;
      downloadHandler?.Dispose();
      downloadHandler = null;
      asyncOperation = null;
    }

    public AssetBundle GetAssetBundle() {
      if (assetBundle == null && downloadHandler != null) {
        assetBundle = downloadHandler.assetBundle;
        downloadHandler.Dispose();
        downloadHandler = null;
      }
      return assetBundle;
    }

    private void BeginOperation() {
      var path = provideHandle.ResourceManager.TransformInternalId(provideHandle.Location);

      if (string.IsNullOrEmpty(path)) {
        asyncOperation = null;
        provideHandle.Complete<S3AssetBundleResource>(null, false, new System.Exception("path to AssetbundleProvider is either null or empty"));
        return;
      }

      if (System.IO.File.Exists(path)) {
        // Bundle already downloaded
        asyncOperation = options == null
          ? AssetBundle.LoadFromFileAsync(path)
          : AssetBundle.LoadFromFileAsync(path, options.Crc);
        asyncOperation.completed += LocalRequestOperationCompleted;
      } else {
        // Maybe bundle is on the server?
        UnityWebRequest req = CreateWebRequest(provideHandle.Location);
        asyncOperation = req.SendWebRequest();
        asyncOperation.completed += WebRequestOperationCompleted;
      };
    }

    private void LocalRequestOperationCompleted(UnityEngine.AsyncOperation operation) {
      assetBundle = (operation as AssetBundleCreateRequest).assetBundle;
      var status = assetBundle != null;
      provideHandle.Complete(this, status, null);
    }

    private void WebRequestOperationCompleted(UnityEngine.AsyncOperation operation) {
      var unityRequest = operation as UnityWebRequestAsyncOperation;
      var webRequest = unityRequest.webRequest;
      if (string.IsNullOrEmpty(webRequest.error)) {
        downloadHandler = webRequest.downloadHandler as DownloadHandlerAssetBundle;
        provideHandle.Complete(this, true, null);
      } else {
        downloadHandler = webRequest.downloadHandler as DownloadHandlerAssetBundle;
        downloadHandler.Dispose();
        downloadHandler = null;

        if (retries++ < options.RetryCount) {
          Debug.LogFormat("Web request {0} failed with error '{1}', retrying ({2}/{3})...",
            webRequest.url,
            webRequest.error,
            retries,
            options.RetryCount
          );
          BeginOperation();
        } else {
          var exception = new System.Exception(
            string.Format("RemoteAssetBundleProvider unable to load from url {0}, result='{1}'.",
              webRequest.url,
              webRequest.error
            )
          );
          provideHandle.Complete<S3AssetBundleResource>(null, false, exception);
        }
      }
      webRequest.Dispose();
    }

    private UnityWebRequest CreateWebRequest(IResourceLocation location) {
      var url = provideHandle.ResourceManager.TransformInternalId(location);
      if (options == null) {
        return UnityWebRequestAssetBundle.GetAssetBundle(url);
      }

      var webRequest = !string.IsNullOrEmpty(options.Hash)
        ? UnityWebRequestAssetBundle.GetAssetBundle(url, Hash128.Parse(options.Hash), options.Crc)
        : UnityWebRequestAssetBundle.GetAssetBundle(url, options.Crc);

      if (options.Timeout > 0)
        webRequest.timeout = options.Timeout;

      if (options.RedirectLimit > 0)
        webRequest.redirectLimit = options.RedirectLimit;

#if !UNITY_2019_3_OR_NEWER
      webRequest.chunkedTransfer = options.ChunkedTransfer;
#endif

      if (provideHandle.ResourceManager.CertificateHandlerInstance != null) {
        webRequest.certificateHandler = provideHandle.ResourceManager.CertificateHandlerInstance;
        webRequest.disposeUploadHandlerOnDispose = false;
      }

      webRequest.disposeDownloadHandlerOnDispose = false;
      return webRequest;
    }
  }
}