# File: /2025_05_openvas_report/src/openvas/api_client.py

from gvm.connections import UnixSocketConnection
from gvm.protocols.gmp import Gmp
from gvm.errors import GvmError

class ApiClient:
    def __init__(self, socket_path='/run/gvmd/gvmd.sock', username='', password=''):
        self.socket_path = socket_path
        self.username = username
        self.password = password
        self.connection = None
        self.gmp = None

    def authenticate(self):
        """Establish connection to GMP and authenticate user."""
        try:
            self.connection = UnixSocketConnection(path=self.socket_path)
            self.gmp = Gmp(self.connection)
            self.gmp.authenticate(self.username, self.password)
            print("[+] Authenticated with gvmd successfully.")
            return True
        except GvmError as e:
            print(f"[!] GMP Authentication error: {e}")
            return False

    def send_command(self, command, **kwargs):
        """Send a GMP command via the Gmp client."""
        try:
            func = getattr(self.gmp, command)
            response = func(**kwargs)
            return response
        except AttributeError:
            print(f"[!] Command {command} not found in GMP client.")
        except GvmError as e:
            print(f"[!] GMP error while sending command: {e}")

    def close(self):
        """Close the connection cleanly."""
        if self.connection:
            self.connection.close()
