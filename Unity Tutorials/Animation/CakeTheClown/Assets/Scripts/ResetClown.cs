using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetClown : MonoBehaviour {

	void ResetClownOnHit () {
		gameObject.transform.localScale = Vector3.one;
		gameObject.GetComponentInChildren<CollisionBehavior> ().collided = false;
	}
}
