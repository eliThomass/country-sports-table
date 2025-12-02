import csv
import collections
import os

# 1. Valid Country Codes from your provided Country table (ISO Alpha-3)
# We will only generate inserts for countries in this list.
valid_iso_codes = {
    'ABW', 'AFG', 'AGO', 'AIA', 'ALB', 'AND', 'ANT', 'ARE', 'ARG', 'ARM', 'ASM', 'ATA', 'ATF', 'ATG', 
    'AUS', 'AUT', 'AZE', 'BDI', 'BEL', 'BEN', 'BFA', 'BGD', 'BGR', 'BHR', 'BHS', 'BIH', 'BLR', 'BLZ', 
    'BMU', 'BOL', 'BRA', 'BRB', 'BRN', 'BTN', 'BVT', 'BWA', 'CAF', 'CAN', 'CCK', 'CHE', 'CHL', 'CHN', 
    'CIV', 'CMR', 'COD', 'COG', 'COK', 'COL', 'COM', 'CPV', 'CRI', 'CUB', 'CXR', 'CYM', 'CYP', 'CZE', 
    'DEU', 'DJI', 'DMA', 'DNK', 'DOM', 'DZA', 'ECU', 'EGY', 'ERI', 'ESH', 'ESP', 'EST', 'ETH', 'FIN', 
    'FJI', 'FLK', 'FRA', 'FRO', 'FSM', 'GAB', 'GBR', 'GEO', 'GHA', 'GIB', 'GIN', 'GLP', 'GMB', 'GNB', 
    'GNQ', 'GRC', 'GRD', 'GRL', 'GTM', 'GUF', 'GUM', 'GUY', 'HKG', 'HMD', 'HND', 'HRV', 'HTI', 'HUN', 
    'IDN', 'IND', 'IOT', 'IRL', 'IRN', 'IRQ', 'ISL', 'ISR', 'ITA', 'JAM', 'JOR', 'JPN', 'KAZ', 'KEN', 
    'KGZ', 'KHM', 'KIR', 'KNA', 'KOR', 'KWT', 'LAO', 'LBN', 'LBR', 'LBY', 'LCA', 'LIE', 'LKA', 'LSO', 
    'LTU', 'LUX', 'LVA', 'MAC', 'MAR', 'MCO', 'MDA', 'MDG', 'MDV', 'MEX', 'MHL', 'MKD', 'MLI', 'MLT', 
    'MMR', 'MNG', 'MNP', 'MOZ', 'MRT', 'MSR', 'MTQ', 'MUS', 'MWI', 'MYS', 'MYT', 'NAM', 'NCL', 'NER', 
    'NFK', 'NGA', 'NIC', 'NIU', 'NLD', 'NOR', 'NPL', 'NRU', 'NZL', 'OMN', 'PAK', 'PAN', 'PCN', 'PER', 
    'PHL', 'PLW', 'PNG', 'POL', 'PRI', 'PRK', 'PRT', 'PRY', 'PSE', 'PYF', 'QAT', 'REU', 'ROM', 'RUS', 
    'RWA', 'SAU', 'SDN', 'SEN', 'SGP', 'SGS', 'SHN', 'SJM', 'SLB', 'SLE', 'SLV', 'SMR', 'SOM', 'SPM', 
    'STP', 'SUR', 'SVK', 'SVN', 'SWE', 'SWZ', 'SYC', 'SYR', 'TCA', 'TCD', 'TGO', 'THA', 'TJK', 'TKL', 
    'TKM', 'TMP', 'TON', 'TTO', 'TUN', 'TUR', 'TUV', 'TWN', 'TZA', 'UGA', 'UKR', 'UMI', 'URY', 'USA', 
    'UZB', 'VAT', 'VCT', 'VEN', 'VGB', 'VIR', 'VNM', 'VUT', 'WLF', 'WSM', 'YEM', 'YUG', 'ZAF', 'ZMB', 
    'ZWE'
}

# 2. Mapping from IOC Codes (CSV) to your ISO Codes (DB)
# Only differences are listed. If IOC==ISO, it is handled automatically.
ioc_to_iso = {
    'ALG': 'DZA', 'ASA': 'ASM', 'ANG': 'AGO', 'AHO': 'ANT', 'ARU': 'ABW', 
    'BAH': 'BHS', 'BAN': 'BGD', 'BAR': 'BRB', 'BER': 'BMU', 'BHU': 'BTN', 
    'BIZ': 'BLZ', 'BOT': 'BWA', 'BRU': 'BRN', 'BUL': 'BGR', 'BUR': 'BFA', 
    'CAM': 'KHM', 'CAY': 'CYM', 'CGO': 'COG', 'CHA': 'TCD', 'CHI': 'CHL', 
    'CRC': 'CRI', 'CRO': 'HRV', 'DEN': 'DNK', 'ESA': 'SLV', 'FIJ': 'FJI', 
    'GAM': 'GMB', 'GBS': 'GNB', 'GEQ': 'GNQ', 'GER': 'DEU', 'GRE': 'GRC', 
    'GRN': 'GRD', 'GUA': 'GTM', 'GUI': 'GIN', 'HAI': 'HTI', 'HON': 'HND', 
    'INA': 'IDN', 'IRI': 'IRN', 'ISV': 'VIR', 'IVB': 'VGB', 'KSA': 'SAU', 
    'KUW': 'KWT', 'LAT': 'LVA', 'LBA': 'LBY', 'LES': 'LSO', 'LIB': 'LBN', 
    'MAD': 'MDG', 'MAS': 'MYS', 'MAW': 'MWI', 'MGL': 'MNG', 'MON': 'MCO', 
    'MRI': 'MUS', 'MTN': 'MRT', 'MYA': 'MMR', 'NCA': 'NIC', 'NED': 'NLD', 
    'NEP': 'NPL', 'NGR': 'NGA', 'NIG': 'NER', 'OMA': 'OMN', 'PAR': 'PRY', 
    'PHI': 'PHL', 'PLE': 'PSE', 'POR': 'PRT', 'PUR': 'PRI', 'ROU': 'ROM', 
    'RSA': 'ZAF', 'SAM': 'WSM', 'SEY': 'SYC', 'SKN': 'KNA', 'SLO': 'SVN', 
    'SOL': 'SLB', 'SRI': 'LKA', 'SUD': 'SDN', 'SUI': 'CHE', 'TAN': 'TZA', 
    'TGA': 'TON', 'TLS': 'TMP', 'TOG': 'TGO', 'TPE': 'TWN', 'UAE': 'ARE', 
    'URU': 'URY', 'VAN': 'VUT', 'VIE': 'VNM', 'VIN': 'VCT', 'ZAM': 'ZMB', 
    'ZIM': 'ZWE'
}

# 3. Mapping Sport Name to SportID
sport_map = {
    'Aeronautics': 1, 'Alpine Skiing': 2, 'Alpinism': 3, 'Archery': 4, 'Art Competitions': 5,
    'Athletics': 6, 'Badminton': 7, 'Baseball': 8, 'Basketball': 9, 'Basque Pelota': 10,
    'Beach Volleyball': 11, 'Biathlon': 12, 'Bobsleigh': 13, 'Boxing': 14, 'Canoeing': 15,
    'Cricket': 16, 'Croquet': 17, 'Cross Country Skiing': 18, 'Curling': 19, 'Cycling': 20,
    'Diving': 21, 'Equestrianism': 22, 'Fencing': 23, 'Figure Skating': 24, 'Football': 25,
    'Freestyle Skiing': 26, 'Golf': 27, 'Gymnastics': 28, 'Handball': 29, 'Hockey': 30,
    'Ice Hockey': 31, 'Jeu De Paume': 32, 'Judo': 33, 'Lacrosse': 34, 'Luge': 35,
    'Military Ski Patrol': 36, 'Modern Pentathlon': 37, 'Motorboating': 38, 'Nordic Combined': 39,
    'Polo': 40, 'Racquets': 41, 'Rhythmic Gymnastics': 42, 'Roque': 43, 'Rowing': 44,
    'Rugby': 45, 'Rugby Sevens': 46, 'Sailing': 47, 'Shooting': 48, 'Short Track Speed Skating': 49,
    'Skeleton': 50, 'Ski Jumping': 51, 'Snowboarding': 52, 'Softball': 53, 'Speed Skating': 54,
    'Swimming': 55, 'Synchronized Swimming': 56, 'Table Tennis': 57, 'Taekwondo': 58, 'Tennis': 59,
    'Trampolining': 60, 'Triathlon': 61, 'Tug-Of-War': 62, 'Volleyball': 63, 'Water Polo': 64,
    'Weightlifting': 65, 'Wrestling': 66
}

def generate_sql(input_file, output_file):
    # Dictionary to store aggregates
    # Key: (CountryCode, SportID, Year)
    # Value: {Gold, Silver, Bronze, NA, Total}
    data = collections.defaultdict(lambda: {'Gold': 0, 'Silver': 0, 'Bronze': 0, 'NA': 0, 'Total': 0})

    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found.")
        return

    print("Processing CSV...")
    with open(input_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            noc = row['NOC']
            sport = row['Sport']
            year = row['Year']
            medal = row['Medal']

            # 1. Map Country
            country_code = ioc_to_iso.get(noc, noc)
            
            # 2. Filter Invalid Countries
            if country_code not in valid_iso_codes:
                continue

            # 3. Map Sport & Filter Invalid Sports
            if sport not in sport_map:
                continue
            sport_id = sport_map[sport]

            # 4. Aggregate
            key = (country_code, sport_id, year)
            
            if medal == 'Gold':
                data[key]['Gold'] += 1
            elif medal == 'Silver':
                data[key]['Silver'] += 1
            elif medal == 'Bronze':
                data[key]['Bronze'] += 1
            else:
                data[key]['NA'] += 1
            data[key]['Total'] += 1

    print(f"Generating SQL for {len(data)} team entries...")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- Generated INSERT statements for OlympicTeam\n")
        f.write("-- Based on athlete_events.csv\n\n")
        
        for (cc, sid, yr), counts in data.items():
            sql = (
                f"INSERT INTO OlympicTeam "
                f"(CountryCode, SportID, Year, GoldCount, SilverCount, BronzeCount, NoMedalCount, TotalParticipants) "
                f"VALUES ('{cc}', {sid}, {yr}, {counts['Gold']}, {counts['Silver']}, {counts['Bronze']}, {counts['NA']}, {counts['Total']});\n"
            )
            f.write(sql)
    
    print(f"Done! Output written to {output_file}")

if __name__ == "__main__":
    # Ensure athlete_events.csv is in the same folder
    generate_sql('athlete_events.csv', 'olympic_team_inserts.sql')