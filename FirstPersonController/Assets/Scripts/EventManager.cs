using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventManager : MonoBehaviour {

    public delegate void EnterAction();
    public static event EnterAction OnEnter;

    private void OnTriggerEnter(Collider other) {
        OnEnter(); //Fire event on entering the trigger
    }
}
