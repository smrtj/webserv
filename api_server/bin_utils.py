import requests

BINLOOKUP_URL = "https://lookup.binlist.net/{}"


def lookup_bin(identifier: str):
    """Return BIN metadata for the given identifier.

    Only the first 8 digits are used. On any request failure,
    an empty dict is returned.
    """
    bin_number = str(identifier)[:8]
    try:
        response = requests.get(BINLOOKUP_URL.format(bin_number))
        response.raise_for_status()
        return response.json()
    except Exception:
        return {}
