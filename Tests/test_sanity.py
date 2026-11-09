import os
import sys

base_dir = os.path.dirname(os.path.abspath(__file__))
if base_dir not in sys.path:
    sys.path.insert(0, base_dir)

import validate_polyglot

def test_polyglot_sanity():
    assert validate_polyglot.test_toc_integrity(), "TOC integrity check failed"
    assert validate_polyglot.test_lua_syntax(), "Lua syntax check failed"
    assert validate_polyglot.test_retail_api_leak(), "Retail API leak check failed"

if __name__ == "__main__":
    test_polyglot_sanity()
