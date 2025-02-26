# Overview
This solution implements a bash script for processing TSLA stock sell orders from a transaction log. The script handles order processing, error management, and generates detailed reports.

# Install linux command #
```
sudo apt-get install jq curl
jq --version
curl --version
```

# Run in a single command ##
```
cat ./transaction-log.txt | jq -r 'select(.symbol == "TSLA" and .side == "sell") | .order_id' | while read order_id; do echo "Processing order ID: $order_id" >&2; curl -v "https://example.com/api/$order_id"
```

# Run in a script ##
```
chmod +x process-tsla-orders.sh
./process-tsla-orders.sh
```
# Output Format ##
## Console Output
```
Starting TSLA sell order processing at 2024-01-20 10:30:15
Processing order 12345... ✓ SUCCESS (Status: 200)
Processing order 12346... ✗ FAILED (Status: 404)

=== Summary ===
Total TSLA sell orders processed: 2
Successful requests: 1
Failed requests: 1
```
# Output File
The script generates output.txt containing detailed response data for each processed order.