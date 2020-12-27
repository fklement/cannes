import os
import json
import cantools

DATA_BASE_DIR = 'dbc_data'
DBC_DATABASE = 'OBD2-v1.4.dbc'

CURRENT_PATH = os.path.dirname(os.path.abspath(__file__))
DATABASE_PATH = os.path.join(CURRENT_PATH, DATA_BASE_DIR, DBC_DATABASE)

print('Start to init DBC database....')
db = cantools.database.load_file(DATABASE_PATH)
print('Done!')

def decode_message(arbitration_id, data, decode_choices, scaling):
    return db.decode_message(arbitration_id, data, decode_choices, scaling)

def encode_message(frame_id, data, scaling, padding, strict):
    return db.encode_message(frame_id, json.loads(data), scaling, padding, strict)