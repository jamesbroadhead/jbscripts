#!/usr/bin/env python
import csv
from pathlib import Path
import re
import sys
from os.path import join as pjoin

import requests



def url_to_dir(url):
    split = url.split('/')
    return '/'.join((split[-2], split[-1]))

def url_to_raw_url(url):
    """
    https://github.com/pivotal-cf/brokerapi/blob/master/LICENSE
    https://raw.githubusercontent.com/pivotal-cf/brokerapi/master/LICENSE
    """
    new = url.replace('github.com', 'raw.githubusercontent.com').replace('blob/', '')
    return new

def get_filename_from_content_disposition_header(cd, default):
    """
    Get filename from content-disposition
    """
    if not cd:
        return default
    fname = re.findall('filename=(.+)', cd)
    if not fname:
        return default
    return fname[0]

def download(url, dir_):
    if not url.startswith('http'):
        url = 'https://' + url

    headers = { 'User-Agent': 'My User Agent 1.0' }
    r = requests.get(url, headers=headers, allow_redirects=True)
    r.raise_for_status()
    filename = get_filename_from_content_disposition_header(
            r.headers.get('content-disposition'), 'LICENSE')
    path = pjoin(dir_, filename)

    with open(path, 'wb') as fh:
        fh.write(r.content)
    return path

def main(csv_file):
    data = {}
    with open(csv_file, mode='r') as fh:
        csv_reader = csv.DictReader(fh)

        for index, row in enumerate(csv_reader):
            if index == 0:
                continue

            url = row['Repository']
            license_url = row['License URL']

            data[url_to_dir(url)] = url_to_raw_url(license_url)

    for dir_, raw_url in data.items():
        Path(dir_).mkdir(parents=True, exist_ok=True)
        download(raw_url, dir_)

if __name__ == '__main__':
    main(sys.argv[1])
