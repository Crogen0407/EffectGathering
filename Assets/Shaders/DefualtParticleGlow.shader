Shader "Custom/DefualtParticleGlow"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        [HDR] _Color ("BaseColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 300

        Pass
        { 
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag 

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            //#pragma _NoLit nolight keepalpha noambient noforwardadd nolightmap novertexlights noshadow

            struct appdata 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };


            sampler2D _MainTex;
            float4 _Color;

			CBUFFER_START(UnityPerMatial)
				float4 _MainTex_ST;
            CBUFFER_END
            
            v2f vert (appdata v) 
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.uv);
                col *= _Color * i.color;
                return col;
            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}


