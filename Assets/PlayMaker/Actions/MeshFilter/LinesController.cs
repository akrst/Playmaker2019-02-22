using UnityEngine;

namespace HutongGames.PlayMaker.Actions
{

[ActionCategory("MeshFilter")]
public class LinesController : FsmStateAction
{
        [RequiredField]
        [UIHint(UIHint.Variable)]
        public MeshFilter meshFilter;
        // Code that runs on entering the state.
        public override void OnEnter()
	{   
            meshFilter.mesh.SetIndices(meshFilter.mesh.GetIndices(0), MeshTopology.Lines, 0);
            Finish();
	}


}

}
