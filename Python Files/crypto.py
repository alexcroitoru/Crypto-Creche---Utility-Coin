import requests
import json
import os

from dotenv import load_dotenv
from pathlib import Path

from web3.auto import w3

load_dotenv()

headers = {
    "Content-Type": "application/json",
    "pinata_api_key": os.getenv("PINATA_API_KEY"),
    "pinata_secret_api_key": os.getenv("PINATA_SECRET_API_KEY"),
}


def initContract():
    with open(Path("Babycoins.json")) as json_file:
        abi = json.load(json_file)

    return w3.eth.contract(address=os.getenv("0x40E246d0567a2d529715c75A4CA8055a70df5ea9"), abi=abi)

def initContract2():
    with open(Path("BabyCoinsJobs.json")) as json_file:
        abi = json.load(json_file)

    return w3.eth.contract(address=os.getenv("0xb25D7F5669bfB0de379fEFF21B464D62c02a8ED0"), abi=abi)


def convertDataToJSON(owner, parent_name, street_address, initial_value, token_uri):
    data = {
        "pinataOptions": {"cidVersion": 1},
        "pinataContent": {
            "owner": owner,
            "parent_name": parent_name,
            "street_address": street_address,
            "initial_value": initial_value,
            "description": token_uri,
        },
    }
    return json.dumps(data)


def pinJSONtoIPFS(json):
    r = requests.post(
        "https://api.pinata.cloud/pinning/pinJSONToIPFS", data=json, headers=headers
    )
    ipfs_hash = r.json()["IpfsHash"]
    return f"ipfs://{ipfs_hash}"
