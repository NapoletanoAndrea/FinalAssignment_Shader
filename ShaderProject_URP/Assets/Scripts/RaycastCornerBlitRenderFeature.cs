using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class RaycastCornerBlitRenderFeature : ScriptableRendererFeature
{
    class CustomRenderPass : ScriptableRenderPass
    {
	    public RenderTargetIdentifier source;
	    private Material material;
	    private RenderTargetHandle tempRenderTargetHandle;

	    public CustomRenderPass(Material material) {
		    this.material = material;
		    tempRenderTargetHandle.Init("_TempRenderTarget");
	    }
        // This method is called before executing the render pass.
        // It can be used to configure render targets and their clear state. Also to create temporary render target textures.
        // When empty this render pass will render to the active camera render target.
        // You should never call CommandBuffer.SetRenderTarget. Instead call <c>ConfigureTarget</c> and <c>ConfigureClear</c>.
        // The render pipeline will ensure target setup and clearing happens in a performant manner.
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
	        
        }

        // Here you can implement the rendering logic.
        // Use <c>ScriptableRenderContext</c> to issue drawing commands or execute command buffers
        // https://docs.unity3d.com/ScriptReference/Rendering.ScriptableRenderContext.html
        // You don't have to call ScriptableRenderContext.submit, the render pipeline will call it at specific points in the pipeline.
        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
	        CommandBuffer commandBuffer = CommandBufferPool.Get("RaycastCornerBlitRenderPass");
            
	        commandBuffer.GetTemporaryRT(tempRenderTargetHandle.id, renderingData.cameraData.cameraTargetDescriptor);
	        Blit(commandBuffer, source, tempRenderTargetHandle.Identifier(), material);
	        Blit(commandBuffer, tempRenderTargetHandle.Identifier(), source);

	        context.ExecuteCommandBuffer(commandBuffer);
	        CommandBufferPool.Release(commandBuffer);
        }
        
        private void RaycastCornerBlit(Camera camera, Material mat) {
	        Camera _camera = camera;
            // Compute Frustum Corners
            float camFar = _camera.farClipPlane;
            float camFov = _camera.fieldOfView;
            float camAspect = _camera.aspect;

            float fovWHalf = camFov * 0.5f;

            Vector3 toRight = _camera.transform.right * Mathf.Tan(fovWHalf * Mathf.Deg2Rad) * camAspect;
            Vector3 toTop = _camera.transform.up * Mathf.Tan(fovWHalf * Mathf.Deg2Rad);

            Vector3 topLeft = (_camera.transform.forward - toRight + toTop);
            float camScale = topLeft.magnitude * camFar;

            topLeft.Normalize();
            topLeft *= camScale;

            Vector3 topRight = (_camera.transform.forward + toRight + toTop);
            topRight.Normalize();
            topRight *= camScale;

            Vector3 bottomRight = (_camera.transform.forward + toRight - toTop);
            bottomRight.Normalize();
            bottomRight *= camScale;

            Vector3 bottomLeft = (_camera.transform.forward - toRight - toTop);
            bottomLeft.Normalize();
            bottomLeft *= camScale;

            // Custom Blit, encoding Frustum Corners as additional Texture Coordinates
            // RenderTexture.active = dest;
            //
            // mat.SetTexture("_MainTex", source);

            GL.PushMatrix();
            GL.LoadOrtho();
		
            mat.SetPass(0);
		
            GL.Begin(GL.QUADS);
		
            GL.MultiTexCoord2(0, 0.0f, 0.0f);
            GL.MultiTexCoord(1, bottomLeft);
            GL.Vertex3(0.0f, 0.0f, 0.0f);
		
            GL.MultiTexCoord2(0, 1.0f, 0.0f);
            GL.MultiTexCoord(1, bottomRight);
            GL.Vertex3(1.0f, 0.0f, 0.0f);
		
            GL.MultiTexCoord2(0, 1.0f, 1.0f);
            GL.MultiTexCoord(1, topRight);
            GL.Vertex3(1.0f, 1.0f, 0.0f);
		
            GL.MultiTexCoord2(0, 0.0f, 1.0f);
            GL.MultiTexCoord(1, topLeft);
            GL.Vertex3(0.0f, 1.0f, 0.0f);
		
            GL.End();
            GL.PopMatrix();
        }

        // Cleanup any allocated resources that were created during the execution of this render pass.
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
        }
    }

    [System.Serializable]
    public class Settings {
	    public Material material;
    }

    public Settings settings;
    CustomRenderPass m_ScriptablePass;

    /// <inheritdoc/>
    public override void Create()
    {
        m_ScriptablePass = new CustomRenderPass(settings.material);

        // Configures where the render pass should be injected.
        m_ScriptablePass.renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
    }

    // Here you can inject one or multiple render passes in the renderer.
    // This method is called when setting up the renderer once per-camera.
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
	    m_ScriptablePass.source = renderer.cameraColorTarget;
        renderer.EnqueuePass(m_ScriptablePass);
    }
}


