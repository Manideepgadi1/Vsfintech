#!/usr/bin/env python3
"""
Find missing indices - compare user's 126 with JSON's 114
"""

# User's complete list - 126 indices
USER_LIST = {
    "BROAD": ["N50", "NN50", "N100", "N200", "NTOTLM", "N500", "NMC5025", "N500EQ", 
              "NMC150", "NMC50", "NMIDSEL", "NMC100", "NSC250", "NSC50", "NSC100", 
              "NMICRO", "NLMC250", "NMSC400", "NQUANT", "NELSS", "NSILVER", "NHSBCYCLE", 
              "NCONTRA", "NGOLD", "NFLEXI", "NINNOV"],  # 26
    "SECTOR": ["NAUTO", "NBANK", "NCHEM", "NFINSERV", "NFINS25", "NFINSEXB", "NFMCG", 
               "NHEALTH", "NTECH", "NMEDIA", "NMETAL", "NPHARMA", "NPVTBANK", "NPSUBANK", 
               "NREALTY", "NCONDUR", "NOILGAS", "NMSFINS", "NMSHC", "NMSITT"],  # 20
    "STRATEGY": ["N100EQWT", "N100LV30", "N5ARB", "N200M30", "N200AL30", "N100AL30", 
                 "NAL50", "NALV30", "NAQLV30", "NAQVLV30", "NDIVOP50", "NGROW15", 
                 "NHBETA50", "NLV50", "NT10EQWT", "NT15EW", "NT20EW", "N100QLT30", 
                 "NM150M50", "N5FCQ3", "N5LV5", "N500M50", "N500QLT50", "NMQLV", 
                 "NMC150Q", "NSC250Q", "N5MCMQ5", "NMSCMQ", "NSC250MQ", "NQLV30", 
                 "N50EQWGT", "N50V20", "N200V30", "N500V50", "N500EQWT", "N200Q30"],  # 36
    "THEMATIC": ["NBIRLA", "NCM", "NCOMM", "NCHOUS", "NCPSE", "NENERGY", "NEVNAA", 
                 "NHOUSING", "N100ESG", "N100ESGE", "N100ESGSL", "NICON", "NIDEF", 
                 "NIDIGI", "NIFSL", "NIINT", "NIMFG", "NTOUR", "NINFRA", "NMAHIN", 
                 "NIPO", "NMIDLIQ15", "NMSICON", "NMNC", "NMOBIL", "NPSE", "NREiT", 
                 "NRRL", "NNCCON", "NSERVSEC", "NSH25", "NTATA", "NTATA25C", "NTRANS", 
                 "NLCLIQ15", "N50SH", "N500SH", "NMFG532", "NINFRA532", "NSMEE", 
                 "NRPSU", "NMAATR", "NNACON", "NWVS"]  # 44
}

# Flatten user list
all_user_indices = set()
for cat, indices in USER_LIST.items():
    all_user_indices.update(indices)

print(f"User's list: {len(all_user_indices)} indices")
print(f"Categories: BROAD={len(USER_LIST['BROAD'])}, SECTOR={len(USER_LIST['SECTOR'])}, STRATEGY={len(USER_LIST['STRATEGY'])}, THEMATIC={len(USER_LIST['THEMATIC'])}")
print(f"Total: {sum(len(v) for v in USER_LIST.values())}")

# Get indices from JSON (we need to extract short names)
# Since we updated the JSON, we need to check what displayNames are in there
import json
with open('/var/www/vsfintech/Right-Sector/data/indices_with_short_names.json', 'r') as f:
    json_data = json.load(f)

json_short_names = {item['displayName'] for item in json_data}
print(f"\nJSON file: {len(json_short_names)} indices")

# Find missing
missing = all_user_indices - json_short_names
print(f"\nMISSING from JSON ({len(missing)} indices):")
for cat, indices in USER_LIST.items():
    cat_missing = [idx for idx in indices if idx in missing]
    if cat_missing:
        print(f"\n{cat} ({len(cat_missing)}):")
        for idx in sorted(cat_missing):
            print(f"  - {idx}")

# Find extra (in JSON but not in user's list)
extra = json_short_names - all_user_indices
if extra:
    print(f"\nEXTRA in JSON (not in user's list) ({len(extra)}):")
    for idx in sorted(extra):
        print(f"  - {idx}")
