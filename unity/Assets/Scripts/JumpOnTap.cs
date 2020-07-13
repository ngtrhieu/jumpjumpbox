using UnityEngine;
using UnityEngine.InputSystem;

public class JumpOnTap : MonoBehaviour {

  public float strength = 100;
  private Rigidbody rb;

  void Start() {
    rb = GetComponent<Rigidbody>();
  }

  void Update() {

    var shouldJump = (
      Keyboard.current != null && Keyboard.current.spaceKey.wasPressedThisFrame ||
      Mouse.current != null && Mouse.current.leftButton.wasPressedThisFrame ||
      Touchscreen.current != null && Touchscreen.current.primaryTouch.tap.wasPressedThisFrame
    );

    if (rb != null && shouldJump) {
      rb.AddForce(Vector3.up * strength);
    }
  }
}