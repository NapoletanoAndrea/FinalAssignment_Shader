Shader "Unlit/TerrainHLSL"
{
    Properties
    {
        _WaterTex ("Water Texture", 2D) = "white" {}
        _WaterColor ("Water Color", Color) = (1,1,1,1)
        
        _LowThreshold ("Low Treshold", Float) = 0
        _LowLerpRange ("Low Range", Float) = 0
        
        _GrassTex ("Grass Texture", 2D) = "white" {}
        _GrassColor ("Grass Color", Color) = (1,1,1,1)
        
        _RockDegrees("Rock Difference", Range(0, 1)) = 0.5
        
        _MidThreshold ("Mid Treshold", Float) = 0
        _MidLerpRange ("Mid Range", Float) = 0
        
        _RockTex ("Rock Texture", 2D) = "white" {}
        _RockColor ("Rock Color", Color) = (1,1,1,1)
        
        _HighThreshold ("High Treshold", Float) = 0
        _HighLerpRange ("High Range", Float) = 0
        
        _SnowTex ("Snow Texture", 2D) = "white" {}
        _SnowColor ("Snow Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "TerrainCompatible" = "True" }
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
                float4 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float4 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _WaterTex;
            float4 _WaterTex_ST;
            
            sampler2D _GrassTex;
            float4 _GrassTex_ST;
            
            sampler2D _RockTex;
            float4 _RockTex_ST;
            
            sampler2D _SnowTex;
            float4 _SnowTex_ST;

            float4 _WaterColor;
            float4 _GrassColor;
            float4 _RockColor;
            float4 _SnowColor;

            float _LowThreshold;
            float _MidThreshold;
            float _HighThreshold;

            float _LowLerpRange;
            float _MidLerpRange;
            float _HighLerpRange;

            float _RockDegrees;

            float remap_float(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            float angle(float3 a, float3 b)
            {
                return acos(dot(a, b));
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 waterCol = tex2D(_WaterTex, i.uv) * _WaterColor;
                float4 grassCol = tex2D(_GrassTex, i.uv) * _GrassColor;
                float4 rockCol = tex2D(_RockTex, i.uv) * _RockColor;
                float4 snowCol = tex2D(_SnowTex, i.uv) * _SnowColor;
                
                if(dot(float3(0,1,0), i.normal) <= _RockDegrees)
                {
                    grassCol = rockCol;
                }
                
                if(i.worldPos.y < _LowThreshold)
                {
                    return waterCol;
                }
                if(i.worldPos.y <= _LowThreshold + _LowLerpRange)
                {
                    float t = remap_float(i.worldPos.y, float2(_LowThreshold, _LowThreshold + _LowLerpRange),
                        float2(0, 1));
                    return lerp(waterCol, grassCol, t);
                }
                if(i.worldPos.y <= _MidThreshold - _MidLerpRange)
                {
                    return grassCol;
                }
                if(i.worldPos.y <= _MidThreshold + _MidLerpRange)
                {
                    float t = remap_float(i.worldPos.y, float2(_MidThreshold - _MidLerpRange, _MidThreshold + _MidLerpRange),
                        float2(0, 1));
                    return lerp(grassCol, rockCol, t);
                }
                if(i.worldPos.y <= _HighThreshold - _HighLerpRange)
                {
                    return rockCol;
                }
                if(i.worldPos.y <= _HighThreshold + _HighLerpRange)
                {
                    float t = remap_float(i.worldPos.y, float2(_HighThreshold - _HighLerpRange, _HighThreshold + _HighLerpRange),
                        float2(0, 1));
                    return lerp(rockCol, snowCol, t);
                }
                
                return snowCol;
            }
            ENDCG
        }
    }
}
