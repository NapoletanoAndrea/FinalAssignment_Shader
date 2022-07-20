using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ColorSplasher : MonoBehaviour {
    [SerializeField] private GameObject spiralPrefab;
    [SerializeField] private GameObject stainPrefab;
    [SerializeField] private Vector3 colorOffset;
        
    [SerializeField] private GameObject sphereMask;
    [SerializeField] private Vector3 sphereOffset;

    [SerializeField] private Transform[] cameraPoints;

    [SerializeField] private Button leftButton;
    [SerializeField] private Button rightButton;
    [SerializeField] private Button spiralButton;
    [SerializeField] private Button stainButton;

    private int currentIndex = 0;

    private Camera cam;
    private GameObject colorPrefab;

    private void Awake() {
        cam = GetComponent<Camera>();
        leftButton.gameObject.SetActive(false);
        leftButton.onClick.AddListener(PrevPos);
        rightButton.onClick.AddListener(NextPos);
        spiralButton.onClick.AddListener(SetSpiral);
        stainButton.onClick.AddListener(SetStain);

        colorPrefab = spiralPrefab;
    }

    private void Update() {
        if (Input.GetMouseButtonDown(0))
        {
            if (EventSystem.current.IsPointerOverGameObject())
                return;
            
            if (Physics.Raycast(cam.ScreenPointToRay(Input.mousePosition), out var hit))
            {
                Instantiate(colorPrefab, hit.point + colorOffset, Quaternion.identity);
                Instantiate(sphereMask, hit.point + sphereOffset, Quaternion.identity);
            }
        }

        if (Input.GetKeyDown(KeyCode.LeftArrow)) {
            PrevPos();
        }

        if (Input.GetKeyDown(KeyCode.RightArrow)) {
            NextPos();
        }
    }
    
    private void PrevPos() {
        currentIndex = Mathf.Clamp(currentIndex - 1, 0, cameraPoints.Length - 1);
        transform.position = cameraPoints[currentIndex].position;
        leftButton?.gameObject.SetActive(currentIndex > 0);
        rightButton?.gameObject.SetActive(currentIndex < cameraPoints.Length - 1);
    }

    private void NextPos() {
        currentIndex = Mathf.Clamp(currentIndex + 1, 0, cameraPoints.Length - 1);
        transform.position = cameraPoints[currentIndex].position;
        leftButton?.gameObject.SetActive(currentIndex > 0);
        rightButton?.gameObject.SetActive(currentIndex < cameraPoints.Length - 1);
    }

    private void SetSpiral() {
        colorPrefab = spiralPrefab;
    }

    private void SetStain() {
        colorPrefab = stainPrefab;
    }
}
