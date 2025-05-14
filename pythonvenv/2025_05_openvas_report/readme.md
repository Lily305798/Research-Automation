# openvas-network-scan
filepath: /home/kali/Documents/Scripts/2025_03_openvas_report.sh
Author: L3l7
Date: May 14, 2025

## Project Overview
This project provides a Python-based interface for interacting with the OpenVAS API to perform network scans. It includes functionality for managing scans, handling API communication, and generating reports based on scan results.

## Directory Structure
```
openvas-network-scan
├── src
│   ├── main.py          # Entry point of the application
│   ├── openvas
│   │   ├── __init__.py  # Marks the openvas directory as a package
│   │   ├── api_client.py # Handles communication with the OpenVAS API
│   │   └── scanner.py    # Manages network scans using the ApiClient
├── tests
│   ├── __init__.py      # Marks the tests directory as a package
│   ├── test_api_client.py # Unit tests for the ApiClient class
│   └── test_scanner.py   # Unit tests for the Scanner class
├── requirements.txt      # Lists project dependencies
├── .gitignore            # Specifies files to ignore in version control
└── README.md             # Project documentation
```

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   cd openvas-network-scan
   ```

2. Install the required dependencies:
   ```
   pip install -r requirements.txt
   ```

3. Configure your OpenVAS API credentials in a secure manner (e.g., using environment variables).

## Usage
To run the application, execute the following command:
```
python src/main.py
```

## Contributing
Contributions are welcome! Please submit a pull request or open an issue for discussion.

## License
This project is licensed under the MIT License. See the LICENSE file for details.