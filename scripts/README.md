# Scripts

## Koji
This python application should help to create a SQL script to insert/update all geofence database entries.  
Needed requirements to install if not already installed:
- pip3 install requests
- pip3 install geojson

### Usage
1. Copy and adapt config.ini

    ```bash
    cp config.ini.default config.ini
    nano config.ini
    ```

2. Run koji.py

    ```bash
    python3 koji.py
    ```

3. Check sql files and import into geofences table
