#!/usr/bin/python3

import os
import json
from pathlib import Path
from typing import List
from pprint import pprint

def get_test_files(output_dir: Path) -> List[Path]:
    p = output_dir.glob('**/*')
    return [x for x in p if x.is_file()]

def process_data(data: json.JSONDecoder) -> None:
    pprint(data)

if __name__ == "__main__":
    output_dir = Path(os.getcwd()) / "output"
    files = get_test_files(output_dir)

    for file_path in files:
        with open(file_path, 'r') as file:
            process_data(json.load(file))
