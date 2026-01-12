# Update Investment Calculator - Quick Guide

## 📦 Quick Update

```powershell
# 1. Upload new files
scp -r "D:\Investment-Calculator" root@82.25.105.18:/var/www/vsfintech/

# 2. Re-run deployment script
ssh root@82.25.105.18
sudo /tmp/deploy-investment-calculator-safe.sh
```

**Done! Updates deployed in 30-60 seconds.**

---

## 🚀 Manual Update (Faster)

### Static HTML:
```powershell
scp -r "D:\Investment-Calculator\*" root@82.25.105.18:/var/www/vsfintech/Investment-Calculator/
```

### React Only:
```powershell
scp -r "D:\Investment-Calculator\*" root@82.25.105.18:/var/www/vsfintech/Investment-Calculator/
ssh root@82.25.105.18 "cd /var/www/vsfintech/Investment-Calculator && npm run build"
```

### React + Backend:
```powershell
scp -r "D:\Investment-Calculator\*" root@82.25.105.18:/var/www/vsfintech/Investment-Calculator/
ssh root@82.25.105.18 "cd /var/www/vsfintech/Investment-Calculator && npm run build && pm2 restart investment-calculator-backend"
```

---

## ✅ Verify Update

```powershell
# Check if it's working
curl http://82.25.105.18/investment-calculator/

# Or open in browser:
# http://82.25.105.18/investment-calculator/
```

**That's it!**
