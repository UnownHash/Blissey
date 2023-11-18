import geojson
import requests
import json
from configparser import ConfigParser

def transform(coordinate):
    return str(coordinate[1]) + " " + str(coordinate[0])

def read_config():
    config = ConfigParser()
    config.read('config.ini')
    return config['API']

def read_data_from_url(url, bearer_token):
    headers = {
        'Authorization': f'Bearer {bearer_token}'
    }

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        json_data = response.json()
        return json_data
    else:
        print(f"Error: {response.status_code}")
        return None

config = read_config()
url_mon = config['mon_url']
url_quest = config['quest_url']
bearer_token = config['bearer_token']

output_file_mon = 'mon_geofences.sql'
output_file_quest = 'quest_geofences.sql'

json_data_mon = read_data_from_url(url_mon, bearer_token)
json_data_quest = read_data_from_url(url_quest, bearer_token)

if json_data_mon and json_data_quest:
    gj_mon = geojson.loads(json.dumps(json_data_mon["data"]))
    gj_quest = geojson.loads(json.dumps(json_data_quest["data"]))

    features_mon = gj_mon['features']
    features_quest = gj_quest['features']

    with open(output_file_mon, 'w') as file_mon:
        for feature in features_mon:
            properties = feature["properties"]
            parent = properties["parent"]
            name = properties["name"]

            geometry = feature["geometry"]
            if geometry["type"] == 'Polygon':
                coordinates = geometry["coordinates"][0]

                geofence = ','.join(map(transform, coordinates))
                result = f"INSERT INTO geofences (`area`, `fence`, `type`, `coords`) VALUES ('{parent}', '{name}', 'mon', '{geofence}') ON DUPLICATE KEY UPDATE `coords` = '{geofence}';"
                file_mon.write(result + '\n')
            else:
                print("Blissey does not support Multi-Polygon")

    with open(output_file_quest, 'w') as file_quest:
        for feature in features_quest:
            properties = feature["properties"]
            parent = properties["name"]
            name = parent

            geometry = feature["geometry"]
            if geometry["type"] == 'Polygon':
                coordinates = geometry["coordinates"][0]

                geofence = ','.join(map(transform, coordinates))
                result = f"INSERT INTO geofences (`area`, `fence`, `type`, `coords`) VALUES ('{parent}', '{name}', 'quest', '{geofence}') ON DUPLICATE KEY UPDATE `coords` = '{geofence}';"
                file_quest.write(result + '\n')
            else:
                print("Blissey does not support Multi-Polygon")

    print("SQL statements have been written to files.")
