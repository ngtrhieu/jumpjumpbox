using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;
using UnityEngine.SceneManagement;

namespace Tests {
  public class PlayModeTest_Main {

    [UnityTest]
    public IEnumerator PlayModeTest_CubeLoadedViaAddressable() {
      SceneManager.LoadScene("Main");

      Assert.Null(GameObject.FindGameObjectWithTag("Cube"));
      yield return new WaitForSeconds(1f);

      Assert.NotNull(GameObject.FindGameObjectWithTag("Cube"));
    }
  }
}
