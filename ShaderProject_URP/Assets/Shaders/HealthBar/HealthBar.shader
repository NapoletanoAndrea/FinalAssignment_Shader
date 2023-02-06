Shader "Unlit/HealthBar"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LowColor ("Low Color", Color) = (1,0,0,1)
        _MidColor ("Mid Color", Color) = (1,1,0,1)
        _HighColor ("High Color", Color) = (0,1,0,1)
        _Health("Health", Range(0, 1)) = 1
        _BlinkHealth("Low Health Threshold", Range(0, 0.5)) = 0.2 
        _BlinkSpeed("Blink Speed", Float) = 2
        
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _LowColor;
            float4 _MidColor;
            float4 _HighColor;
            float _Health;
            float _BlinkHealth;
            float _BlinkSpeed;

            float remap_float(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(0,0,0,1);
                if(i.uv.x <= _Health)
                {
                    if(_Health > _BlinkHealth)
                    {
                        float remappedHealth = remap_float(_Health, float2(_BlinkHealth, 1), float2(0, 1));
                        col = lerp(_MidColor, _HighColor, remappedHealth);
                    }
                    else
                    {
                        col = _LowColor;
                        if(sin(_Time.y * _BlinkSpeed) > 0)
                        {
                            col = fixed4(1,1,1,1);
                        }
                    }
                }
                return col;
            }
            ENDCG
        }
    }
}
