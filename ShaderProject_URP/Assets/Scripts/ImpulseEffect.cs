using UnityEngine;

public class ImpulseEffect : MonoBehaviour {
    [SerializeField] private float speed;

    private Material mat;

    private float startTime;
    private float lastSin;
    
    private static readonly int UseShaderTime = Shader.PropertyToID("_UseShaderTime");
    private static readonly int Flow = Shader.PropertyToID("_Flow");
    private static readonly int Speed = Shader.PropertyToID("_Speed");

    private void Awake() {
        mat = GetComponent<MeshRenderer>().material;
        mat.SetInt(UseShaderTime, 0);
        mat.SetFloat(Speed, speed);
    }

    private void Start() {
        startTime = Time.time;
    }

    private void Update() {
        mat.SetFloat(Flow, Time.time - startTime);
        var sin = Mathf.Sin((Time.time - startTime) * mat.GetFloat(Speed));
        if (sin < lastSin) {
            lastSin = sin;
            Destroy(gameObject);
        }
    }
}
