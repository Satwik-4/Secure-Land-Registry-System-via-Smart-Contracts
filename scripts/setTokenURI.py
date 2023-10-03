from scripts.helpful_scripts import get_account
from brownie import Land, network, config
from Upload.upload import upload

def setTokenURI(_ID, _District, _State, _LandArea, _Location):

    account = get_account()

    hash = upload(_ID, _District, _State, _LandArea, _Location)

    tx = Land[-1].createCollectible({"from" : account})
    #tx.wait()

    tx_1 = Land[-1].setTokenURI(_ID, f"https://gateway.pinata.cloud/ipfs/{hash}", {"from": account})

def main():
    setTokenURI(0, "Nizamabad", "Telangana", "44 Acres", "Plot No: 11-1-1950/4, Gangasthan-1")
