Shader "Unlit/Anim_Shader2_3d"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", range(0, 0.5)) = 0.1
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color B", color) = (1, 1, 1, 1)
        
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
               float xOffset = cos(v.uv.y * TAU * 8) * 0.1;
               float yOffset = cos(v.uv.x * TAU * 8) * 0.1;
               float t = cos((v.uv.x + yOffset + xOffset + _Time.y * 0.1) * TAU * 5) * 5 + 0.5;
               //v.vertex.y = t * (_Amplitude * yOffset) + (_Amplitude * xOffset);     
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                //float someoffset = sin(i.uv.y * 6.28);
                float xOffset = cos(i.uv.y * TAU * 8) * 0.1;
                float yOffset = cos(i.uv.x * TAU * 8) * 0.1;
                float t = cos((i.uv.x + yOffset + xOffset + _Time.y * 0.1) * TAU * 5) * 5 + 0.5;
                float4 r = lerp(_ColorA, _ColorB, t);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return r;
            }
            ENDCG
        }
    }
}
