using System.Collections;
using UnityEngine;
using UnityEngine.Playables;

public class TimelinePlaybackManager : MonoBehaviour {


	[Header("Timeline References")]
	public PlayableDirector playableDirector;

	[Header("Trigger Zone Settings")]
	public GameObject triggerZoneObject;

	private bool playerInZone = false;
	private bool timelinePlaying = false;
	private float timelineDuration;

	public void PlayerEnteredZone(){
		playerInZone = true;
	}

	public void PlayerExitedZone(){
		playerInZone = false;
	}
		
	void Update(){
		if (playerInZone && !timelinePlaying) {
			PlayTimeline ();
		}
	}

	public void PlayTimeline(){
		if (playableDirector) {
			playableDirector.Play ();
		}
			
		triggerZoneObject.SetActive (false);
		timelinePlaying = true;
			
		StartCoroutine (WaitForTimelineToFinish());
	}

	IEnumerator WaitForTimelineToFinish(){
		timelineDuration = (float)playableDirector.duration;
		
		yield return new WaitForSeconds(timelineDuration);
		
		playerInZone = false;
		timelinePlaying = false;
	}
}