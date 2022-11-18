Shader "Unlit/Anim_Shader6"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", range(0, 0.02)) = 0
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color B", color) = (1, 1, 1, 1)
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            
            //blend one one //Additive blend mode.
            //blend DstColor zero //Multiplicative blend mode.
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define TAU 6.28
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _Amplitude;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                 float xOffset = cos(v.uv.x * TAU * 8 - _Time.y) * 0.1;
                float someoffset = cos(v.uv.y * TAU * 8 - _Time.y) * 0.1;
                float t = cos((v.uv.y + xOffset + someoffset * 0.1) * TAU * 4) * 5 + 0.5;
                v.vertex.y = t * _Amplitude;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float xOffset = cos(i.uv.x * TAU * 8 - _Time.y) * 0.1;
                float someoffset = cos(i.uv.y * TAU * 8 - _Time.y) * 0.1;
                float t = cos((i.uv.y + xOffset + someoffset * 0.1) * TAU * 4) * 5 + 0.5;
                float4 tLerp = lerp(_ColorA, _ColorB, t);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return tLerp;
            }
            ENDCG
        }
    }
}
