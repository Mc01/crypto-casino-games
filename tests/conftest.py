#!/usr/bin/python3

import pytest


@pytest.fixture(scope="function", autouse=True)
def isolate(fn_isolation):
    pass


@pytest.fixture(scope="module")
def charity_profile(CharityProfile, accounts):
    return accounts[0].deploy(CharityProfile)
