using UnityEngine;
using Matrix4x4 = UnityEngine.Matrix4x4;
using Vector3 = UnityEngine.Vector3;

public class SimpleController : MonoBehaviour {
    public float speed;
    [SerializeField] private Matrix4x4 matrix;

    private void Awake() {
        var result = matrix.MultiplyVector(new Vector3(2,2,2));
        Debug.Log(result);
    }

    void Update() {
        var move = new Vector3(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        transform.position += move * Time.deltaTime * speed;
    }
}
