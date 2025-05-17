from pythonosc import udp_client

def send_message(address, port, kontrol, modtager, bpm, sekvens):
    """
    Sender en besked til Sonic Pi via OSC
    --------------
    Args:
        address: OSC adresse
        port: portnummer (Sonic Pi default: 4560)
        kontrol: besked[0]
        modtager: besked[1]  (maskin nr. skal sættes i sonic pi)
        bpm: besked[2]
        sekvens: besked[3]
    """
    sender = udp_client.SimpleUDPClient(address, port)
    trigger_besked = [modtager, sekvens, bpm, kontrol]
    print("Sender besked til Sonic Pi: ")
    print("adresse...", address, ":", port)
    print("kontrol...: ", kontrol)
    print("modtager..: ", modtager)
    print("bpm.......: ", bpm)
    print("sekvens...: ", sekvens)
    sender.send_message('/trigger', trigger_besked)

if __name__ == "__main__":
    # get parameters from command line
    import sys
    print ("Sonic Pi OSC Trigger")
    print("antal parametre: ", len(sys.argv))
    print("parametre: ", sys.argv)
    if len(sys.argv) != 6:
        print()
        print("Usage: python main.py <address:port> <kontrol> <modtager> <bpm> <sekvens>")
        print()
        print("Sonic Pi default port: 4560")
        print()
        sys.exit(1)

    # addresse har form 1.2.3.4:4560 - check for colon and split this in ip and port
    address = sys.argv[1]
    if ':' in address:
        address, port = address.split(':')
        port = int(port)
    else:
        port = 4560
    kontrol = int(sys.argv[2])
    modtager = int(sys.argv[3])
    bpm = int(sys.argv[4])
    sekvens = int(sys.argv[5])
    # send message
    send_message(address, port, kontrol, modtager, bpm, sekvens)
