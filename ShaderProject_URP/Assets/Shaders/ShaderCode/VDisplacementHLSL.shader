Shader "Unlit/VDisplacementHLSL"
{
    Properties
    {
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Intensity ("Intensity", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            float _Intensity;

            v2f vert (appdata v)
            {
                v2f o;
                float noiseValue = tex2Dlod(_NoiseTex, float4(v.uv, 0, 0));
                v.vertex += v.normal * noiseValue * _Intensity;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(1,0,0,0);
            }
            ENDCG
        }
    }
}
