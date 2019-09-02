Shader "SemiTransparentGuideLineGradation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TopColor("Color1", Color) = (1, 1, 1, 1)
        _ButtomColor("Color2", Color) = (1, 1, 1, 1)       
        _TopColorPos("Top Color Pos", Range(0, 1)) = 1 //初期値は1
        _TopColorAmount("Top Color Amount", Range(0, 1)) = 0.5 //初期値は0.5

    }

    SubShader
    {
        Tags {"Queue" =  "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };

        fixed4 _TopColor;
        fixed4 _ButtomColor;
        fixed _TopColorPos;
        fixed _TopColorAmount;
        sampler2D _MainTex;

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            fixed amount = clamp(abs(_TopColorPos - i.uv_MainTex.y) + (0.5 - _TopColorAmount), 0, 1);
            fixed4 color = lerp(_TopColor, _ButtomColor, amount);
            o.Emission = color.rgb;
            float alpha = 1 - (abs(dot(i.viewDir, i.worldNormal)));
            o.Alpha = alpha * 3.5f;
        }
        ENDCG
    }
    Fallback "Diffuse"
}