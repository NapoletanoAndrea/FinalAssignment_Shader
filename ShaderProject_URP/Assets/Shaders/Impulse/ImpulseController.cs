using UnityEngine;

public class ImpulseController : MonoBehaviour
{
    public Transform ScannerOrigin;
    public Material EffectMaterial;
    public float ScanDistance;

    bool _scanning;

    void Update()
    {
        if (_scanning)
        {
            ScanDistance += Time.deltaTime * 50;
            EffectMaterial.SetFloat("_ScanDistance", ScanDistance);
        }

        if (Input.GetKeyDown(KeyCode.C))
        {
            _scanning = true;
            ScanDistance = 0;
        }

        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                _scanning = true;
                ScanDistance = 0;
                ScannerOrigin.position = hit.point;
                EffectMaterial.SetVector("_WorldSpaceScannerPos", ScannerOrigin.position);
            }
        }
    }
}
