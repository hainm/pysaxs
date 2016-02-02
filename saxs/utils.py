from collections import namedtuple

def convert_dict_to_namedtuple(dictionary):
    # from: https://gist.github.com/href/1319371
    return namedtuple('GenericDict', dictionary.keys())(**dictionary)
