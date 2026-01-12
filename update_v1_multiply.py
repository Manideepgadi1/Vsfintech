import paramiko
import time

# VPS credentials
hostname = "82.25.105.18"
username = "root"
password = "Mevivs@2026"

# Connect to VPS
print("Connecting to VPS...")
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname, username=username, password=password)

print("✓ Connected")

# Backup and update
commands = [
    "cp /var/www/risk-reward/app.py /var/www/risk-reward/app.py.backup_v1_200",
    "sed -i \"s/result\\['V1'\\] = round(1 - V1_PERCENTILE_MAP\\[index_name\\], 2)/result['V1'] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)/\" /var/www/risk-reward/app.py",
    "systemctl restart risk-reward"
]

for cmd in commands:
    print(f"\nExecuting: {cmd}")
    stdin, stdout, stderr = ssh.exec_command(cmd)
    output = stdout.read().decode()
    error = stderr.read().decode()
    
    if output:
        print(f"Output: {output}")
    if error and "warning" not in error.lower():
        print(f"Error: {error}")

print("\n✓ V1 updated to multiply by 200")

# Test API
print("\nTesting API...")
time.sleep(2)
stdin, stdout, stderr = ssh.exec_command("curl -s http://localhost:8003/api/risk-return | head -c 500")
response = stdout.read().decode()
print(f"API Response: {response[:200]}...")

ssh.close()
print("\n✓ Complete! V1 formula: (1 - v1) * 200")
