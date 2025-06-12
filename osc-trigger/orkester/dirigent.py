import time
from time import sleep
from kompostion import BPM, PARTITUR
from osc_settings import OSC_ENDPOINT_START, OSC_ENDPOINT_STOP, OSC_ENDPOINT_BPM
from sonic_pi_monitor import SonicPiMonitor
from osc_settings import CLIENT_HOST_ADDRESSES
import threading

# Example usage
if __name__ == "__main__":
    monitor = SonicPiMonitor()

    # Add Sonic Pi clients for all clients in composition
    for client_name, ip_host_address in CLIENT_HOST_ADDRESSES.items():
        monitor.add_client(client_name, ip_host_address)

    def play_composition():
        time.sleep(2)  # Let monitor start first

        print("BPM:", BPM)

        # Synchronize all machines to the same BPM
        for client in monitor.clients.keys():
            monitor.update_client_status(client, alt_text=f"Init BPM: {BPM}")
            monitor.send_command(client, OSC_ENDPOINT_BPM, BPM)

        # convert BMP to seconds to sleep
        bpm_in_seconds = 60 / BPM
        print("BPM in seconds:", bpm_in_seconds)
        sleep(2)

        # start timer to use to keep track of beats
        start_time = time.time()

        while True:
            # Calculate current beat based on elapsed time - rounded to lowest whole number
            elapsed_time = time.time() - start_time
            current_beat = int(elapsed_time / bpm_in_seconds)
            monitor.update_beat(current_beat)

            #for part_name, part in partitions:
            for part_name, partition in PARTITUR.items():
                client = partition['client']
                start = partition['start_beat']
                length = partition['length']
                is_currently_playing = partition.get('playing', False)

                partition['name'] = part_name  # Add name to partition for status updates

                if isinstance(start, list):
                    start_playing = False
                    for i in range(len(start)):
                        start_playing = is_partition_playing(start[i], length, current_beat) or start_playing

                else:
                    start_playing = is_partition_playing(start, length, current_beat)

                if start_playing:
                    # Update client status to playing
                    if not is_currently_playing:
                        print(f"Starting {part_name} on {client} at beat {current_beat}")
                        monitor.send_command(client, OSC_ENDPOINT_START, part_name)
                        partition['playing'] = True
                else:
                    if is_currently_playing:
                        # Update client status to stopped
                        print(f"Stopping {part_name} on {client} at beat {current_beat}")
                        monitor.send_command(client, OSC_ENDPOINT_STOP, part_name)
                        partition['playing'] = False

                monitor.update_client_status(client, partition)

            time.sleep(bpm_in_seconds)

            # Find the lagest start-beat in the partitions
            max_start_beat = max(
                [start if isinstance(start, int) else max(start) for _, part in PARTITUR.items() for start in [part['start_beat']]]
            )
            is_anything_playing = current_beat <= max_start_beat or any(part.get('playing', False) for _, part in PARTITUR.items())
            if not is_anything_playing:
                print()
                print("✅ DONE! All partitions are played. Exiting...")
                print("   (Ctrl-x to stop the monitor)")
                print()
                print()
                exit(0)

    def is_partition_playing(start, length, current_beat):
        return (start + length) > current_beat >= start

    live_thread = threading.Thread(target=play_composition, daemon=True)
    live_thread.start()

    # Start the monitor
    print("Starting Sonic Pi Composition Monitor...")
    print("Press Ctrl+C to stop")
    print()
    monitor.run_monitor()