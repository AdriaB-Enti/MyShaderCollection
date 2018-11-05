Shader "PostPro/MultipleVisionEffect"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		//ignore last two numbers
		_Direction("Direction (x,y) & distance", Vector) = (0.1,0,0,0)
		_Repetitions("Repetitions", Int) = 2
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		//alpha blending
		Blend SrcAlpha OneMinusSrcAlpha

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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			Vector _Direction;
			int _Repetitions;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 startPoint = - (_Direction.xy * _Repetitions / 2.0f);	//offset vector where the first 'layer' is drawn
				fixed4 totalCol = (0);

				for (int r = 0; r < _Repetitions; r++) {
					float2 currentPoint = startPoint + float(r)*_Direction.xy;
					totalCol += tex2D(_MainTex, i.uv + currentPoint) / _Repetitions;
				}

				return totalCol;
			}
			ENDCG
		}
	}
}
