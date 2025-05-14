# File: /openvas-network-scan/openvas-network-scan/src/main.py

import sys
from openvas.api_client import ApiClient
from openvas.scanner import Scanner

def main():
    # Initialize the OpenVAS API client
    api_client = ApiClient()
    
    # Authenticate with the OpenVAS API
    if not api_client.authenticate():
        print("Authentication failed.")
        sys.exit(1)

    # Create a scanner instance
    scanner = Scanner(api_client)

    # Start a network scan
    scan_id = scanner.create_scan(target='192.168.1.1', name='My Network Scan')
    if scan_id:
        print(f"Scan created with ID: {scan_id}")
        scanner.start_scan(scan_id)
        print("Scan started.")
    else:
        print("Failed to create scan.")

if __name__ == "__main__":
    main()