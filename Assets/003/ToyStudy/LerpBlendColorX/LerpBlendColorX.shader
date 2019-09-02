Shader "TS/LerpBlendColorX"
{
	Properties
	{
		[HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _Seam("Seam", Range(0.001, 0.999)) = 0.5
        _Color001("Color001", Color) =(0, 0, 0, 0)
        _Color002("Color002", Color) =(1, 1, 1, 1)
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
            float _Seam;
            float4 _Color001;
            float4 _Color002;
			
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
                // このピクセルのuv.x が_Seam未満なら_Color001、以上なら_Color002を返す
                return lerp(_Color001, _Color002, step(_Seam, i.uv.x));

			}
			ENDCG
		}
	}
}
