using UnityEngine;

public class JumpOnTap : MonoBehaviour {

  public float strength = 100;
  private Rigidbody rb;

  void Start() {
    rb = GetComponent<Rigidbody>();
  }

  void Update() {
    if (rb != null && (
            Input.GetKeyDown(KeyCode.Space) ||
            Input.GetMouseButtonDown(0)
        )
    ) {
      rb.AddForce(Vector3.up * strength);
    }
  }
}