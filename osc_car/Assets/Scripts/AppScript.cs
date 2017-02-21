using UnityEngine;
using System.Collections;

using UnityOSC;
using System.Collections.Generic;

public class AppScript : MonoBehaviour {

	public GameObject car;

    public int oscPort = 7000;

    private OSCServer server;
    private ServerLog serverLog;

    // Use this for initialization
    void Start () {


        // init server
        server = new OSCServer(oscPort);
        server.PacketReceivedEvent += Server_PacketReceivedEvent;
        

        // init server log
        serverLog = new ServerLog();
        serverLog.server = server;
        serverLog.log = new List<string>();
        serverLog.packets = new List<OSCPacket>();

    }

    private void Server_PacketReceivedEvent(OSCServer sender, OSCPacket packet)
    {
        Debug.LogWarning("Packet received!");
        Loom.QueueOnMainThread(() => {
            RotateCarY((float)packet.Data[0]);
        });
        
         
    }


    void RotateCarY(float rotationDelta) {
        car.GetComponent<Rigidbody>().AddTorque(new Vector3(0, 100*rotationDelta * Time.deltaTime, 0), ForceMode.Acceleration);
    }

    // Update is called once per frame
    void Update () {
        car.GetComponent<Rigidbody>().angularVelocity *= 0.99f;	
	}

    void OnApplicationQuit() {
        // deinit OSC
        server.Close();
    }

}
