Shader "Unlit/Circle_Shader3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", range(0, 10)) = 0.0
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color B", color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define TAU 6.283185307179586

            float _Amplitude;

            #include "UnityCG.cginc"

           float4 _ColorA;
           float4 _ColorB;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

             float GetWave(float2 uv)
            {
                float2 CenterUVs = uv *2 -1;
                float RadDistance = length(CenterUVs);
                float wave = cos((RadDistance - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                wave *= 1 - RadDistance;
                return wave;
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                v.vertex.y = GetWave(v.uv) * _Amplitude;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float t = GetWave(i.uv);
                float4 Lerpresult = lerp(_ColorA, _ColorB, t);
                
              return Lerpresult; //GetWave(i.uv)
                //return float4(RadialDistance.xxx, 1);
               
            }
            ENDCG
        }
    }
}
