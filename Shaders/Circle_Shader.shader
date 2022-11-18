Shader "Unlit/Circle_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", range(0, 1)) = 0
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
            #define TAU 6.28
            float _Amplitude;

            #include "UnityCG.cginc"

            float GetWave(float2 uv)
            {
                 float2 CenteredUVs = uv * 2 -1;
                float RadialDistance = length(CenteredUVs);
                float wave = cos((RadialDistance - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                return wave;
            }

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

            v2f vert (appdata v)
            {
                v2f o;
                v.uv.y = GetWave(v.uv) * _Amplitude;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
               float2 CenteredUVs = i.uv * 2 -1;
               float RadialDistance = length(CenteredUVs);
               float wave = cos((RadialDistance - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
               return wave;
                //return float4(RadialDistance.xxx, 1);
                //return GetWave(i.uv) * _Amplitude;
               
            }
            ENDCG
        }
    }
}
