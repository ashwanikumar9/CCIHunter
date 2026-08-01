import json
import asyncio
from settings import TYPED_AST_CODE, NODE_PATH
from utils.tmpfile import wrap_run4tmpfile

async def get_typed_ast_items(ast_json: dict) -> list:
    """
    Executes the typed_ast.js script using Node.js to extract specific typed AST nodes.
    """
    async def _run(path):
        proc = await asyncio.create_subprocess_shell(
            f"{NODE_PATH} {path}",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        out, err = await proc.communicate()
        items = []
        for line in out.decode().splitlines():
            if not line.strip():
                continue
            try:
                items.append(json.loads(line))
            except Exception:
                pass
        return items

    script_content = TYPED_AST_CODE % json.dumps(ast_json)
    return await wrap_run4tmpfile(script_content, _run)
