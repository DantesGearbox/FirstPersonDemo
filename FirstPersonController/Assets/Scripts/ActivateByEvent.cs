using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateByEvent : MonoBehaviour {

    private void OnEnable() {
        EventManager.OnEnter += DoSomething;
    }

    private void OnDisable() {
        EventManager.OnEnter -= DoSomething;
    }

    private void DoSomething() {
        Debug.Log("Event fired and seen");
    }
}
