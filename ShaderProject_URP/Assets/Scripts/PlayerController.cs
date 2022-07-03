using UnityEngine;

public class PlayerController : MonoBehaviour {
    [SerializeField] private float speed;

    private Rigidbody rb;
    private Animator ani;

    private Vector2 movementInput;
    private Vector3 direction;
    
    private static readonly int IsWalking = Animator.StringToHash("IsWalking");

    private void Awake() {
        rb = GetComponent<Rigidbody>();
        ani = GetComponent<Animator>();
    }

    private void Update() {
        movementInput = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        direction = new Vector3(movementInput.x, 0, movementInput.y);
        ani.SetBool(IsWalking, movementInput.magnitude > .1f);
    }

    private void FixedUpdate() {
        rb.velocity = direction * speed * Time.fixedDeltaTime;
    }
}
