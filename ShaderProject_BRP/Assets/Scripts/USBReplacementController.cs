using UnityEngine;

[ExecuteInEditMode]
public class USBReplacementController : MonoBehaviour
{
	// replacement shader
	public Shader m_replacementShader;
	private void OnEnable()
	{
		if(m_replacementShader != null)
		{
			// the camera will replace all the shaders in the scene
			// with the replacement one the render type configuration
			GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
		}
	}
	private void OnDisable()
	{
		// reset the default shader
		GetComponent<Camera>().ResetReplacementShader();
	}
}