using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionBehavior : MonoBehaviour {

	public bool collided;

	void OnCollisionEnter (Collision collision) {
		if (!collided) {
			collided = true;

			GameObject clown = gameObject.transform.parent.gameObject;
			Animator clownAnimator = clown.GetComponent<Animator> ();
			clownAnimator.SetTrigger ("hit");
		}
	}
}
