import os
import tempfile
import asyncio

async def wrap_run4tmpfile(data: str, async_func) -> any:
    # We must use settings.TMP_FILE_DIR if it exists, or just tempfile
    import settings
    tmp_dir = getattr(settings, 'TMP_FILE_DIR', None)
    
    # Create a temporary file
    fd, path = tempfile.mkstemp(dir=tmp_dir, text=True)
    try:
        # Write the data to the temp file
        with os.fdopen(fd, 'w', encoding='utf-8') as f:
            f.write(data)
            
        # Run the async function with the file path
        result = await async_func(path)
        return result
    finally:
        # Clean up the temporary file
        if os.path.exists(path):
            os.remove(path)
