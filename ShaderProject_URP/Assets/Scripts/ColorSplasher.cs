using UnityEngine;
using UnityEngine.EventSystems;

public class ColorSplasher : MonoBehaviour {
    [SerializeField] private GameObject colorPrefab;
    [SerializeField] private Vector3 colorOffset;
        
    [SerializeField] private GameObject sphereMask;
    [SerializeField] private Vector3 sphereOffset;

    private Camera cam;

    private void Awake() {
        cam = GetComponent<Camera>();
    }

    private void Update() {
        if (EventSystem.current.IsPointerOverGameObject())
            return;
        
        if (Input.GetMouseButtonDown(0))
        {
            if (Physics.Raycast(cam.ScreenPointToRay(Input.mousePosition), out var hit))
            {
                Instantiate(colorPrefab, hit.point + colorOffset, Quaternion.identity);
                Instantiate(sphereMask, hit.point + sphereOffset, Quaternion.identity);
            }
        }
    }
}
