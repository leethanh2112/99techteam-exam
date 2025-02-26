# First, ensure we start with a clean output file
rm -f ./output.txt && touch ./output.txt && \
echo "Starting TSLA sell order processing at $(date '+%Y-%m-%d %H:%M:%S')" && \
cat ./transaction-log.txt | jq -r 'select(.symbol == "TSLA" and .side == "sell") | .order_id' | \
while read order_id; do 
    echo -n "Processing order $order_id... "
    response=$(curl -s -w "\n%{http_code}" "https://example.com/api/$order_id")
    status_code=$(echo "$response" | tail -n1)
    content=$(echo "$response" | sed '$d')
    
    if [ "$status_code" -eq 200 ]; then
        echo -e "\e[32m✓ SUCCESS\e[0m (Status: $status_code)"
        echo "Response for order $order_id: $content" >> ./output.txt
        ((success_count++))
    else
        echo -e "\e[31m✗ FAILED\e[0m (Status: $status_code)"
        echo "Failed request for order $order_id: Status $status_code" >> ./output.txt
        ((error_count++))
    fi
done && \
echo -e "\n=== Summary ===" && \
echo "Total TSLA sell orders processed: $((success_count + error_count))" && \
echo -e "\e[32mSuccessful requests: $success_count\e[0m" && \
echo -e "\e[31mFailed requests: $error_count\e[0m" && \
echo "Results saved to: ./output.txt" && \
echo "Completed at $(date '+%Y-%m-%d %H:%M:%S')" && \
echo -e "\nContents of output.txt:" && \
cat ./output.txt

