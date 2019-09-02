Shader "TS/RingColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Frequency("Frequency", Float) = 4
        _RingWidth("RingWidth", Range(0, 0.999)) = 0.999
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
            float _Frequency;
            float _RingWidth;

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
                fixed length = distance(i.uv, fixed2(0.5, 0.5));
                return step(_RingWidth, sin(length * _Frequency));
			}
			ENDCG
		}
	}
}
