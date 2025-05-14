# File: openvas-network-scan/openvas-network-scan/tests/test_scanner.py

import unittest
from src.openvas.scanner import Scanner
from unittest.mock import MagicMock

class TestScanner(unittest.TestCase):

    def setUp(self):
        self.api_client_mock = MagicMock()
        self.scanner = Scanner(self.api_client_mock)

    def test_create_scan(self):
        # Test creating a scan
        self.api_client_mock.create_scan.return_value = {'scan_id': '12345'}
        scan_id = self.scanner.create_scan('Test Scan', '192.168.1.1')
        self.assertEqual(scan_id, '12345')
        self.api_client_mock.create_scan.assert_called_once_with('Test Scan', '192.168.1.1')

    def test_start_scan(self):
        # Test starting a scan
        self.api_client_mock.start_scan.return_value = True
        result = self.scanner.start_scan('12345')
        self.assertTrue(result)
        self.api_client_mock.start_scan.assert_called_once_with('12345')

    def test_get_scan_status(self):
        # Test getting scan status
        self.api_client_mock.get_scan_status.return_value = 'Completed'
        status = self.scanner.get_scan_status('12345')
        self.assertEqual(status, 'Completed')
        self.api_client_mock.get_scan_status.assert_called_once_with('12345')

if __name__ == '__main__':
    unittest.main()