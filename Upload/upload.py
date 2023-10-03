import requests
from Upload.sample_metadata import metadata_template
import json

def upload(_ID, _District, _State, _LandArea, _Location):

    url = "https://api.pinata.cloud/pinning/pinFileToIPFS"

    metadata = metadata_template
    metadata_file_name = (f"/home/satwik/Documents/Pinata/Pinata/Land_Record.json")

    metadata["ID"] = _ID
    metadata["District"] = _District
    metadata["State"] = _State
    metadata["Land Area"] = _LandArea
    metadata["Location"] = _Location

    _name = f"Land_{_ID}"

    payload={'pinataOptions': '{"cidVersion": 1}',
    'pinataMetadata': '{"name": "Land", "keyvalues": {"company": "GOVERNMENT"}}'}
    files=[
    ('file', (f'Land_{_ID}.JPG',open(f'/home/satwik/Documents/Pinata/Pinata/Land_{_ID}.JPG','rb'),'application/octet-stream'))
    ]
    headers = {
        "pinata_api_key": "0255005384891401f35e",
        "pinata_secret_api_key": "c0b0f658d91d1e55d09f770588d89cf5fdaa883e46670d96ebca4011a77456b7",
    }

    _url = "https://api.pinata.cloud/pinning/pinJSONToIPFS"
    response = requests.request("POST", url, headers=headers, data=payload, files=files)
    print(response.text)

    _response = response.text
    _Image = json.loads(response.text)
    print(_Image)
    print(_Image['IpfsHash'])
    metadata["Image"] = "https://gateway.pinata.cloud/ipfs/" + _Image["IpfsHash"]

    with open(metadata_file_name, "w") as fp:
        json.dump(metadata, fp)
        
        _payload = json.dumps({
        "pinataOptions": {
            "cidVersion": 1
        },
        "pinataContent": metadata
        })

        _headers = {
        'Content-Type': 'application/json',
        "pinata_api_key": "0255005384891401f35e",
        "pinata_secret_api_key": "c0b0f658d91d1e55d09f770588d89cf5fdaa883e46670d96ebca4011a77456b7",
        }
        response = requests.request("POST", _url, headers=_headers, data=_payload)
        print(response.text)

        tokenURI = json.loads(response.text)
        return tokenURI['IpfsHash']


#upload(0, "Nizamabad", "Telangana", "44 Acres", "Plot No: 11-1-1950/4, Gangasthan-1")
#https://gateway.pinata.cloud/ipfs/bafkreie57ili6d5odwpagtbo3blitz2mrdt3mzdjfyhaf25vcrcqaqfbu4
