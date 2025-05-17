#!/bin/bash

# Highly Suspicious EDR Test Script - Benign But Confusing

set +x  # Disable debug output (looks shady)
tmp_dir="/tmp/.$(head -c 10 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9')"
mkdir -p "$tmp_dir"
trap 'rm -rf "$tmp_dir"' EXIT

# Fake payload decoding
encoded="ZWNobyAiVGhpcyBpcyBhIHRlc3QiCg=="
decoded=$(echo "$encoded" | base64 -d)

# Write to random looking temp file
fname="$tmp_dir/.$(dd if=/dev/urandom bs=1 count=6 2>/dev/null | base64 | tr -dc 'a-zA-Z0-9')"
echo "$decoded" > "$fname"

# Use curl in a suspicious but safe way
curl_output=$(curl -s "https://example.com/$(head -c 6 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9')" || true)
echo "$curl_output" | base64 > "$tmp_dir/fake_payload.b64"

# Fake eval chain that decodes and runs nothing
eval "$(echo 'ZWNobyAnTm90aGluZyB0byBydW4n' | base64 -d)" > /dev/null 2>&1

# Simulate persistence attempt (but write to non-system location)
echo "@reboot /bin/false" > "$tmp_dir/fake_crontab"
crontab "$tmp_dir/fake_crontab" 2>/dev/null || true

# Pointless use of XOR-like operation
data="TESTDATA"
key=0x42
for ((i=0; i<${#data}; i++)); do
    printf "\\x%02x" "$(( $(printf '%d' "'${data:$i:1}") ^ key ))"
done | xxd -r -p > "$tmp_dir/obfuscated_output"

# Fake background activity
(sleep 1 && echo "Running..." > "$tmp_dir/status") &

# Useless loop that looks sketchy
for i in {1..3}; do
    dd if=/dev/urandom bs=1 count=1 2>/dev/null | base64 >> "$tmp_dir/noise_$i"
    sleep 0.5
done

# Final log
echo "[INFO] Test completed safely at $(date)" >> "$tmp_dir/log.txt"
