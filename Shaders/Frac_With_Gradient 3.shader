Shader "Unlit/Frac_With_Gradient3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", color) = (1, 1, 1, 1)
        _ColorB("Color B", color) = (1, 1, 1, 1)
        _ColorC("Color C", color) = (1, 1, 1, 1)
        _ColorD("Color D", color) = (1, 1, 1, 1)
        _StartValue("Start value",range(0, 1)) = 0
        _EndValue("End value", range(0, 1)) = 1
        _Offset("Offset", range(0,1)) = 0
        _Amplitude("Amplitude", range(0, 0.5)) = 0.1
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

            float4 _ColorA;
            float4 _ColorB;
            float4 _ColorC;
            float4 _ColorD;
            float _StartValue;
            float _EndValue;
            float _Offset;
            float _Amplitude;

            float InverseLerp(float a, float b, float v)
            {
                return (v - a)/(b - a);
            }
            
            
            #include "UnityCG.cginc"
            #define TAU 6.28

            

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.uv = v.uv;
                //float xOffset = o.uv.y;
                //float xOffset2 = cos(o.uv.x * TAU * 8) * 0.02;
                //float4 OutputPattern = cos((o.uv.x + xOffset + xOffset2) * TAU * 5 + _Time.y) * 2 + 0.5;
                //v.vertex.y = OutputPattern * _Amplitude;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.normal = UnityObjectToWorldNormal(v.normals); 
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.normal = v.normals; Normals in local space.
                o.normal = UnityObjectToWorldNormal(v.normals); //Normals in world space.
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float xOffset = i.uv.y;
                float yOffset = i.uv.x;
                //float t = cos(_StartValue + _EndValue);
                float n = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 5 + 0.5;
               // a = frac(a);
               // b = frac(b);

                float xOffset2 = cos(i.uv.y * TAU * 8) * 0.02;
                float xOffset3 = cos(i.uv.y);
                //float someoffset = sin(i.uv.y * 6.28);
                float t = cos((i.uv.y + xOffset2 - _Time.y * 0.1) * TAU * 5) * 5 + 0.5;

                //return t;
                float4 OutputPattern = cos((i.uv.x + xOffset + xOffset2) * TAU * 5 + _Time.y) * 2 + 0.5;
                //float output = lerp(_ColorA, _ColorB, OutputColor);
                return OutputPattern;
                
                //return float4(i.uv, 0, 1);
                //return float4(i.normal, 1);
            }
            ENDCG
        }
    }
}
