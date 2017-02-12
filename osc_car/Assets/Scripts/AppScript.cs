using UnityEngine;
using System.Collections;

public class AppScript : MonoBehaviour {

	public GameObject car;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		car.transform.Rotate (new Vector3 (0, 30*Time.deltaTime, 0));
	}
}
