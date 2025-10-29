# File: /2025_05_openvas_report/src/openvas/scanner.py

from gvm.errors import GvmError
import time

class Scanner:
    def __init__(self, api_client):
        self.api_client = api_client
        self.gmp = api_client.gmp

    def create_scan(self, target, name='Scan'):
        """Create a scan target and task, then return task ID."""
        try:
            # Create target
            target_response = self.gmp.create_target(name=name, hosts=target)
            target_id = target_response.get('id')
            print(f"[+] Target created with ID: {target_id}")

            # Get scanner ID (usually only one exists)
            scanners = self.gmp.get_scanners()
            scanner_id = scanners.xpath('scanner/@id')[0]
            print(f"[+] Using Scanner ID: {scanner_id}")

            # Create task
            task_response = self.gmp.create_task(
                name=f"{name} Task",
                config_id=self._get_config_id(),
                target_id=target_id,
                scanner_id=scanner_id
            )
            task_id = task_response.get('id')
            print(f"[+] Task created with ID: {task_id}")

            return task_id

        except GvmError as e:
            print(f"[!] Error creating scan: {e}")
            return None

    def start_scan(self, task_id):
        """Start the task (scan) given a task ID."""
        try:
            self.gmp.start_task(task_id)
            print(f"[+] Scan started for task {task_id}")
        except GvmError as e:
            print(f"[!] Error starting scan: {e}")

    def get_scan_status(self, task_id):
        """Return the current status of the scan."""
        try:
            task = self.gmp.get_task(task_id=task_id)
            status = task.xpath('task/status/text()')[0]
            print(f"[+] Scan status: {status}")
            return status
        except GvmError as e:
            print(f"[!] Error retrieving scan status: {e}")
            return None

    def get_scan_results(self, task_id):
        """Retrieve the report ID and fetch the report XML."""
        try:
            task = self.gmp.get_task(task_id=task_id)
            report_id = task.xpath('task/last_report/report/@id')[0]
            print(f"[+] Report ID: {report_id}")

            report_response = self.gmp.get_report(report_id=report_id)
            report_xml = report_response.to_string()
            return report_xml

        except GvmError as e:
            print(f"[!] Error retrieving scan results: {e}")
            return None

    def _get_config_id(self, name='Full and fast'):
        """Helper to retrieve a scan config ID by name."""
        configs = self.gmp.get_scan_configs()
        for config in configs.xpath('config'):
            if config.xpath('name/text()')[0] == name:
                return config.get('id')
        raise ValueError(f"Scan config '{name}' not found.")
