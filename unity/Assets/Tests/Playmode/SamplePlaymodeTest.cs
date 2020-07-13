using System.Collections;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

public class SamplePlaymodeTests {

  // https://docs.unity3d.com/Packages/com.unity.test-framework@1.1/manual/reference-attribute-unitytest.html
  // Behave similar to a coroutine, only with Assertion.
  [UnityTest]
  public IEnumerator PlayModeTestsWithEnumeratorPasses() {
    // Use the Assert class to test conditions.
    // yield to skip a frame
    Assert.True(true);
    yield return null;
    Assert.True(true);
  }
}