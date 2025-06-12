from pythonosc import udp_client
from rich.live import Live
from rich.table import Table
from rich.console import Console
from rich.text import Text
from time import sleep
from osc_settings import IP_NET, PORT

class SonicPiMonitor:
    def __init__(self):
        self.console = Console()
        self.clients = {}
        self.client_status = {}
        self.current_beat = 0

    def update_beat(self, beat):
        """Update the current beat in the monitor"""
        self.current_beat = beat

    def add_client(self, client_name, ip_host_address):
        """Add a Sonic Pi client"""
        self.clients[client_name] = udp_client.SimpleUDPClient(IP_NET + ip_host_address, PORT)
        self.client_status[client_name] = {
            'partitions': [],
            'alt_text': None  # Placeholder for additional text if needed
        }

    def update_client_status(self, client_name, part=None, alt_text=None):
        """Update status of a client"""
        if client_name in self.client_status:
            if part is not None and part not in self.client_status[client_name]['partitions']:
                self.client_status[client_name]['partitions'].append(part)
            self.client_status[client_name]['alt_text'] = alt_text
        else:
            print(f"\n[red]Client {client_name} not found. Please add it first.[/red]")

    def send_command(self, client_name, osc_path, *args):
        """Send OSC command to a specific client"""

        if client_name in self.clients:
            try:
                self.clients[client_name].send_message(osc_path, *args)
            except OSError as e:
                print(f"Network error sending to {client_name}: {e}")
                # Optionally update client status to show error
                self.update_client_status(client_name, alt_text=f"Network Error ({self.clients[client_name]._address}:{self.clients[client_name]._port})")

    def create_status_table(self):
        """Create the status table"""
        table = Table(title="🎵 CODING PIRATES Composition Monitor for Sonic Pi π)))", show_header=True)
        table.add_column("Sonic Pi", style="cyan", width=15)
        table.add_column("Status", width=10)
        table.add_column("Sekvens", width=15)
        table.add_column("Progress", width=35)
        table.add_column(f"Beat #{self.current_beat}", width=20)

        for client_name, status in self.client_status.items():
            # Status column with colored indicator
            is_client_playing = any(p.get('playing', False) for p in status['partitions'])
            if is_client_playing:
                status_text = Text("●", style="bold green") + Text(" Playing", style="green")
            else:
                status_text = Text("●", style="bold red") + Text(" Stopped", style="red")

            if len(status['partitions']) == 0:
                progress_text = "-" if status['alt_text'] is None else status['alt_text']
                table.add_row(client_name, status_text, "-", progress_text, "-")
            else:
                for index, part in enumerate(status['partitions']):
                    # Sequence column
                    sequence_text = part['name']

                    is_partition_playing = part.get('playing', False)

                    # Progress column
                    if is_partition_playing:
                        # find the current beat in the partition that is playing
                        if isinstance(part['start_beat'], list):
                            current_playing_start_beat = max([start for start in part['start_beat'] if start <= self.current_beat])
                        else:
                            current_playing_start_beat = part['start_beat']
                        # Create a simple progress bar using characters
                        elapsed_beats = self.current_beat - current_playing_start_beat
                        part_length = part['length']
                        progress_pct = 0 if elapsed_beats < 0 else 1 if part_length == 1 else elapsed_beats / part_length
                        bar_width = 20
                        filled = int(progress_pct * bar_width)
                        bar = "█" * filled + "░" * (bar_width - filled)
                        progress_text = f"{bar} {progress_pct*100:3.0f}% (#{current_playing_start_beat})"
                    else:
                        progress_text = "" if status['alt_text'] is None else status['alt_text']

                    # Beat text
                    # if its a list format to string separated with comma
                    if isinstance(part['start_beat'], list):
                        start_beat = ",".join(str(beat) for beat in part['start_beat'])
                    else:
                        start_beat = str(part['start_beat'])
                    if is_partition_playing:
                        beat_text = Text(start_beat, style="bold green")
                    else:
                        beat_text = Text(start_beat, style="grey")

                    if index == 0:
                        # Only add client and status once
                        table.add_row(client_name, status_text, sequence_text, progress_text, beat_text)
                    else:
                        table.add_row("", "", sequence_text, progress_text, beat_text)

        return table

    def run_monitor(self):
        """Run the live monitoring display"""
        with Live(self.create_status_table(), refresh_per_second=5, console=self.console) as live:
            try:
                while True:
                    live.update(self.create_status_table())
                    sleep(0.2)
            except KeyboardInterrupt:
                self.console.print("\n[yellow]Monitor stopped[/yellow]")
