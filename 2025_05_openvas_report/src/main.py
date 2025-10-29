# File: /2025_05_openvas_report/src/main.py

import sys
from openvas.api_client import ApiClient
from openvas.scanner import Scanner

def main():
    # Initialize the OpenVAS API client
    api_client = ApiClient('/run/gvmd/gvmd.sock', 'admin', 'password')
    
    # Authenticate with the OpenVAS API
    if not api_client.authenticate():
        print("Authentication failed.")
        sys.exit(1)
    else:
        version_info = api_client.send_command('get_version')
        print(version_info)

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