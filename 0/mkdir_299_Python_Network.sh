#!/bin/bash

# Create the project directory structure
mkdir -p 0x10-python-network_0
cd 0x10-python-network_0 || exit

# Create README.md
echo "# 0x10-python-network_0 Project" > README.md

# Create and configure 0-body_size.sh
echo "#!/bin/bash" > 0-body_size.sh
echo "# This script takes a URL, sends a request, and displays the size of the body in bytes." >> 0-body_size.sh
echo "curl -s -w \"%{size_download}\" \"\$1\" -o /dev/null" >> 0-body_size.sh
chmod +x 0-body_size.sh

# Create and configure 1-body.sh
echo "#!/bin/bash" > 1-body.sh
echo "# This script sends a GET request and displays the body only if the status code is 200." >> 1-body.sh
echo "curl -s -o /dev/null -w \"%{http_code}\" \"\$1\" | grep -q \"200\" && curl -s \"\$1\"" >> 1-body.sh
chmod +x 1-body.sh

# Create and configure 2-delete.sh
echo "#!/bin/bash" > 2-delete.sh
echo "# This script sends a DELETE request and displays the body of the response." >> 2-delete.sh
echo "curl -X DELETE -s \"\$1\"" >> 2-delete.sh
chmod +x 2-delete.sh

# Create and configure 3-methods.sh
echo "#!/bin/bash" > 3-methods.sh
echo "# This script sends a request and displays the accepted HTTP methods." >> 3-methods.sh
echo "curl -s -I \"\$1\" | grep Allow | cut -d ' ' -f2-" >> 3-methods.sh
chmod +x 3-methods.sh

# Create and configure 4-header.sh
echo "#!/bin/bash" > 4-header.sh
echo "# This script sends a GET request with a custom header and displays the body." >> 4-header.sh
echo "curl -H \"X-School-User-Id: 98\" -s \"\$1\"" >> 4-header.sh
chmod +x 4-header.sh

# Create and configure 5-post_params.sh
echo "#!/bin/bash" > 5-post_params.sh
echo "# This script sends a POST request with specified parameters and displays the body." >> 5-post_params.sh
echo "curl -X POST -d \"email=test@gmail.com&subject=I will always be here for PLD\" -s \"\$1\"" >> 5-post_params.sh
chmod +x 5-post_params.sh

# Create 6-peak.py
echo "def find_peak(list_of_integers):" > 6-peak.py
echo "    if not list_of_integers:" >> 6-peak.py
echo "        return None" >> 6-peak.py
echo "    low, high = 0, len(list_of_integers) - 1" >> 6-peak.py
echo "    while low < high:" >> 6-peak.py
echo "        mid = (low + high) // 2" >> 6-peak.py
echo "        if list_of_integers[mid] > list_of_integers[mid + 1]:" >> 6-peak.py
echo "            high = mid" >> 6-peak.py
echo "        else:" >> 6-peak.py
echo "            low = mid + 1" >> 6-peak.py
echo "    return list_of_integers[low]" >> 6-peak.py

# Create 6-peak.txt
echo "O(log(n))" > 6-peak.txt

# Create and configure 100-status_code.sh
echo "#!/bin/bash" > 100-status_code.sh
echo "# This script displays only the status code of a request." >> 100-status_code.sh
echo "curl -s -o /dev/null -w \"%{http_code}\" \"\$1\"" >> 100-status_code.sh
chmod +x 100-status_code.sh

# Create and configure 101-post_json.sh
echo "#!/bin/bash" > 101-post_json.sh
echo "# This script sends a JSON POST request and displays the body of the response." >> 101-post_json.sh
echo "curl -X POST -H \"Content-Type: application/json\" -d \"@\$2\" -s \"\$1\"" >> 101-post_json.sh
chmod +x 101-post_json.sh

# Create and configure 102-catch_me.sh
echo "#!/bin/bash" > 102-catch_me.sh
echo "# This script sends a request to catch_me and displays the response body." >> 102-catch_me.sh
echo "curl -H \"User-Agent: YouGotMe\" -s \"0.0.0.0:5000/catch_me\"" >> 102-catch_me.sh
chmod +x 102-catch_me.sh

# End of script