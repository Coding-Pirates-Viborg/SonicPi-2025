from pythonosc import osc_message_builder
from pythonosc import udp_client
sender = udp_client.SimpleUDPClient('127.0.0.1', 4560)
sender.send_message('/trigger', ["60"])
#sender.send_message('/trigger', ["A", 70, 4])