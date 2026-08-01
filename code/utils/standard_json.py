import json

def get_sol_standard_json(code: str, optimized: bool, runs: int = 200) -> dict:
    """
    Format Solidity source code into standard JSON input format expected by solc.
    """
    return {
        "language": "Solidity",
        "sources": {
            "contract.sol": {
                "content": code
            }
        },
        "settings": {
            "optimizer": {
                "enabled": optimized,
                "runs": runs
            },
            "outputSelection": {
                "*": {
                    "*": ["ast", "devdoc", "userdoc"],
                    "": ["ast"]
                }
            }
        }
    }
