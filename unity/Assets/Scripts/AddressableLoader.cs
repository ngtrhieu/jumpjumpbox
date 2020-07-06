using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;

public class AddressableLoader : MonoBehaviour {

  public AssetReferenceGameObject refGameObject;

  void Start() {
    refGameObject.InstantiateAsync(transform.position, transform.rotation);
  }
}