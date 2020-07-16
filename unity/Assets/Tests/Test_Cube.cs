using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;

namespace Tests {

  [TestFixture]
  public class PlayModeTest_Cube : InputTestFixture {

    [UnityTest]
    public IEnumerator CubeLoadViaAddressable() {

      SceneManager.LoadScene("Main");
      Assert.Null(GameObject.FindGameObjectWithTag("Cube"));

      yield return new WaitForSeconds(1f);

      Assert.NotNull(GameObject.FindGameObjectWithTag("Cube"));
    }

    [UnityTest]
    public IEnumerator CubeJumpAfterPressSpace() {
      SceneManager.LoadScene("Main");

      // Wait for the cube to spawn and come to rest
      yield return new WaitForSeconds(1f);

      var cube = GameObject.FindGameObjectWithTag("Cube");
      var originalPosition = cube.transform.position;

      // Send jump action
      var keyboard = InputSystem.AddDevice<Keyboard>();
      var pressSpaceAction = new InputAction("jump", binding: "<Keyboard>/space", interactions: "Press");
      pressSpaceAction.Enable();

      Press(keyboard.spaceKey);

      // Box jump shortly after
      yield return new WaitForSeconds(0.1f);

      Assert.Greater(cube.transform.position.y, originalPosition.y);
      Assert.Greater(cube.GetComponent<Rigidbody>().velocity.sqrMagnitude, 0);
      Assert.Greater(cube.GetComponent<Rigidbody>().velocity.normalized.y, 0);

      yield return new WaitForSeconds(1f);

    }
  }
}
