using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;
using UnityEngine.SceneManagement;

namespace Tests {
  public class PlayModeTest_Cube {

    [UnityTest]
    public IEnumerator NewTestScriptWithEnumeratorPasses() {

      SceneManager.LoadScene("Main");
      Assert.Null(GameObject.FindGameObjectWithTag("Cube"));

      yield return new WaitForSeconds(1);

      Assert.NotNull(GameObject.FindGameObjectWithTag("Cube"));
    }
  }
}
