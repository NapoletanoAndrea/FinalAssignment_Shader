Shader "Unlit/WaterUnlit"
{
    Properties
    {
        _WaterTex ("Water Texture", 2D) = "white" {}
        _TexSpeedMul("Texture Speed Mul", Float) = 0.1
        _WaterTint("WaterTint", Color) = (1,1,1,1)
        _WaterSpeedX("Water Speed X", Float) = 1
        _WaterSpeedZ("Water Speed Z", Float) = 1
        _WavesFrequency("Waves Frequency", Float) = 1
        _WavesHeight("Waves Height", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _WaterTex;
            float4 _WaterTex_ST;
            float4 _WaterTint;

            float _WavesHeight;
            float _WavesFrequency;
            float _WaterSpeedX;
            float _WaterSpeedZ;
            float _TexSpeedMul;

            v2f vert (appdata v)
            {
                v2f o;
                
                float2 wavesTime = float2(_Time.y * _WaterSpeedX, _Time.y * _WaterSpeedZ);
                
                o.uv = TRANSFORM_TEX(v.uv, _WaterTex) + wavesTime * _TexSpeedMul;
                
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                float mask = sin(length(float2(worldPos.x, worldPos.z) - wavesTime) * _WavesFrequency);

                v.vertex.y += _WavesHeight * mask;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_WaterTex, i.uv) * _WaterTint;
                return col;
            }
            ENDCG
        }
    }
}
