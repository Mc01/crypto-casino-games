#!/usr/bin/python3

from brownie import *


def main():
    CharityProfile.deploy({'from': accounts[0]})
