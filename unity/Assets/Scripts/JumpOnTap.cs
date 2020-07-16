using UnityEngine;
using UnityEngine.InputSystem;

public class JumpOnTap : MonoBehaviour {

  public float strength = 100;
  private Rigidbody rb;

  private BoxInput input;
  private bool shouldJump;

  void Start() {
    rb = GetComponent<Rigidbody>();

    input = new BoxInput();
    input.Enable();
    input.Box.Jump.performed += ctx => shouldJump = true;
  }

  void Update() {
    if (rb != null && shouldJump) {
      shouldJump = false;
      rb.AddForce(Vector3.up * strength);
    }
  }

  void OnDestroy() {
    input.Disable();
  }
}