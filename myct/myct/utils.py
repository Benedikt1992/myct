import argparse

def split_key_value(string):
    key, value = string.split('=', 1)
    return {'key': key, 'value': value}
