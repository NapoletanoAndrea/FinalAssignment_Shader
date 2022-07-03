using System.Collections;
using UnityEngine;

public class ImpulseEffectGenerator : MonoBehaviour {
    [SerializeField] private GameObject impulseEffectPrefab;
    [SerializeField] private float generationDelay;

    private void Start() {
        StartCoroutine(GenerateEffectCoroutine());
    }

    private IEnumerator GenerateEffectCoroutine() {
        while (true) {
            yield return new WaitForSeconds(generationDelay);
            var effectInstance = Instantiate(impulseEffectPrefab, transform);
            effectInstance.transform.parent = null;
        }
    }
}
