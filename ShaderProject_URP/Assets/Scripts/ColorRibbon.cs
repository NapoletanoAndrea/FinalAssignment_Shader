using UnityEngine;

public class ColorRibbon : MonoBehaviour {
    [SerializeField] private AnimationCurve widthCurve;
    [SerializeField] private float widthMultiplier;

    [SerializeField] private AnimationCurve heightCurve;
    [SerializeField] private float heightMultiplier;

    [SerializeField] private AnimationCurve ribbonWidthCurve;
    [SerializeField] private float ribbonWidthMultiplier;

    [SerializeField] private float startFallSeconds;
    [SerializeField] private float fallSpeed;

    [SerializeField] private bool destroyAfterSeconds;
    [SerializeField] private float destroySeconds;

    private Material ribbonMaterial;
    
    private float count;

    private void Awake() {
        ribbonMaterial = GetComponent<MeshRenderer>().material;
    }

    private void Update() {
        if (count > destroySeconds && destroyAfterSeconds) {
            Destroy(gameObject);
        }
        
        count += Time.deltaTime;
        
        float finalSize = widthCurve.Evaluate(count) * widthMultiplier;
        transform.localScale = new Vector3(finalSize, transform.localScale.y, finalSize);
        
        finalSize = heightCurve.Evaluate(count) * heightMultiplier;
        transform.localScale = new Vector3(transform.localScale.x, finalSize, transform.localScale.z);
        
        finalSize = ribbonWidthCurve.Evaluate(count) * ribbonWidthMultiplier;
        ribbonMaterial.SetFloat("_Width", finalSize);

        if (count > startFallSeconds) {
            transform.position += Vector3.down * fallSpeed * Time.deltaTime;
        }
    }
}
