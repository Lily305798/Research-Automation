import unittest
from openvas.api_client import ApiClient

class TestApiClient(unittest.TestCase):

    def setUp(self):
        self.client = ApiClient(base_url='http://localhost:9390', username='admin', password='admin')

    def test_authentication(self):
        self.assertTrue(self.client.authenticate())

    def test_send_request(self):
        response = self.client.send_request('GET', '/some/api/endpoint')
        self.assertEqual(response.status_code, 200)

    def test_receive_response(self):
        response = self.client.send_request('GET', '/some/api/endpoint')
        data = self.client.receive_response(response)
        self.assertIsInstance(data, dict)

if __name__ == '__main__':
    unittest.main()