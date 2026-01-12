import re

# Read current file
with open('/var/www/risk-reward/app.py', 'r') as f:
    content = f.read()

# Backup
with open('/var/www/risk-reward/app.py.backup_v1_100', 'w') as f:
    f.write(content)

# Update V1 calculation from 200 to 100
old_line = "result['V1'] = round((1 - V1_PERCENTILE_MAP[index_name]) * 200, 2)"
new_line = "result['V1'] = round((1 - V1_PERCENTILE_MAP[index_name]) * 100, 2)"
new_content = content.replace(old_line, new_line)

# Write updated content
with open('/var/www/risk-reward/app.py', 'w') as f:
    f.write(new_content)

print("V1 updated successfully - now multiplies by 100")
