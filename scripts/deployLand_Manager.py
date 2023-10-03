from scripts.helpful_scripts import get_account
from brownie import Land_Manager, network, config


def deploy():

    account = get_account(0)
    Land_Manager.deploy({"from": account}, publish_source = config["networks"][network.show_active()]["verify"])

def main():
    deploy()