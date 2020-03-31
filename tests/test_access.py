#!/usr/bin/python3

def test_owner(charity_profile, accounts):
    assert charity_profile.owner() == accounts[0]

def test_add_to_whitelist(charity_profile, accounts):
    assert charity_profile.whitelist(accounts[1]) == False
    charity_profile.add_to_whitelist(accounts[1])
    assert charity_profile.whitelist(accounts[1]) == True

def test_remove_from_whitelist(charity_profile, accounts):
    charity_profile.add_to_whitelist(accounts[1])
    charity_profile.remove_from_whitelist(accounts[1])
    assert charity_profile.whitelist(accounts[1]) == False
