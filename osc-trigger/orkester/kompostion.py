from osc_settings import *

BPM = 60

PARTITUR = {
    "Stortromme": {
        "client": CLIENT_ESGE,
        "start_beat": [1,5,9,14,16],
        "length": 1, # length in beats
    },
    "Lilletromme": {
        "client": CLIENT_ESGE,
        "start_beat": [3, 11, 18],
        "length": 1,
    },
    "SW Theme 1": {
        "client": CLIENT_ESGE,
        "start_beat": 5,
        "length": 9,
    },
    "SW Theme 2": {
        "client": CLIENT_ESGE,
        "start_beat": 14,
        "length": 8,
    },
    "Nyt tema": {
        "client": CLIENT_SIMON,
        "start_beat": [22],
        "length": 8,
    },
}