import os
from typing import Optional

def write(path: str, key: str, value: str) -> int:
    if "\n" in key or "\t" in key:
        raise ValueError("key cannot contain '\\n' or '\\t'")
    if "\n" in value:
        raise ValueError("value cannot contain '\\n'")

    line = f"{key}\t{value}\n"

    with open(path, "a", encoding="utf-8") as f:
        f.write(line)
        f.flush()
        os.fsync(f.fileno())

    return len(line.encode("utf-8"))

def read(path: str, key: str, *, chunk_size: int = 64 * 1024) -> Optional[str]:
    if not os.path.exists(path):
        return None

    key_prefix = key + "\t"

    file_size = os.path.getsize(path)
    if file_size == 0:
        return None

    with open(path, "rb") as f:
        pos = file_size
        tail = b""

        while pos > 0:
            read_size = min(chunk_size, pos)
            pos -= read_size

            f.seek(pos)
            block = f.read(read_size)

            data = block + tail
            lines = data.split(b"\n")

            if pos > 0:
                tail = lines[0]
                complete_lines = lines[1:]
            else:
                tail = b""
                complete_lines = lines

            for line in reversed(complete_lines):
                if not line:
                    continue

                try:
                    decoded = line.decode("utf-8")
                except UnicodeDecodeError:
                    continue

                if decoded.startswith(key_prefix):
                    return decoded[len(key_prefix):]

        return None