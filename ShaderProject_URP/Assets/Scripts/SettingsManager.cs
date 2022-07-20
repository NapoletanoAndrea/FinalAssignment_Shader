using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.SceneManagement;

public class SettingsManager : MonoBehaviour {
    public UniversalAdditionalCameraData cameraData;
    public int index;

    private void Awake() {
        if (cameraData) {
            cameraData.SetRenderer(index);
        }
    }

    public void Restart() {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }

    public void Quit() {
        Application.Quit();
    }

    public void ChangeScene(int buildIndex) {
        SceneManager.LoadScene(buildIndex);
    }
}
