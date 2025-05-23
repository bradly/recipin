#!/usr/bin/env python3

import json
import sys
from ingredient_parser import parse_ingredient

def parse_ingredient_to_json(ingredient_str):
    try:
        i = parse_ingredient(ingredient_str)
        return {
            "name": [n.text for n in i.name] if i.name else [],
            "amount": [a.text for a in i.amount] if i.amount else [],
            "size": i.size.text if i.size else None,
            "preparation": i.preparation.text if i.preparation else None,
            "comment": i.comment.text if i.comment else None,
            "purpose": i.purpose.text if i.purpose else None,
            "sentence": i.sentence
        }
    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    # Check if an argument was provided
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Missing ingredient parameter"}))
    else:
        ingredient = sys.argv[1]
        result = parse_ingredient_to_json(ingredient)
        print(json.dumps(result))
