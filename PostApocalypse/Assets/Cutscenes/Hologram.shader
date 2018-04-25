Shader "Custom Shaders/SpecialFX/Hologram"
{
	Properties
	{
		//Model texture
		_MainTex ("Albedo Texture", 2D) = "white" {}

		//For Hologram Glitching
		_Distance("Distance", Float) = 1
		_Amplitude("Amplitude", Float) = 1
		_Speed("Speed", Float) = 1
		_Amount ("Amount", Range(0.0, 1.0)) = 1

		//For scanlines/hologram effect
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_Bias("Bias", Float) = 0
		_ScanningFrequency ("Scanning Frequency", Float) = 100
		_ScanningSpeed ("Scanning Speed", Float) = 100

	}
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Transparent" }
		LOD 100

		ZWrite Off
		Blend SrcAlpha One
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;

				float4 objVertex : TEXCOORD1;

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			//For Hologram Glitching
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;

			//For scanlines/hologram effect
			float4 _TintColor;
			float _Bias;
			float _ScanningFrequency;
			float _ScanningSpeed;
			
			v2f vert (appdata v)
			{
				v2f o;

				//Vertex in world space, used for scanlines/hologram effect
				o.objVertex = mul(unity_ObjectToWorld, v.vertex);

				//Offset x by a sin function based on time, used for hologram glitching
				v.vertex.x += sin((_Time.y * _Speed) + (v.vertex.y * _Amplitude)) * _Distance * _Amount;

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				//For scanlines/hologram effect
				col = _TintColor * max(0, cos(i.objVertex.y * _ScanningFrequency + _Time.x * _ScanningSpeed) + _Bias);
				col *= 1 - max(0, cos(i.objVertex.x * _ScanningFrequency + _Time.x * _ScanningSpeed) + 0.9);
				col *= 1 - max(0, cos(i.objVertex.z * _ScanningFrequency + _Time.x * _ScanningSpeed) + 0.9);

				return col;
			}
			ENDCG
		}
	}
}
