import random
import string
from sdb import write

DB_FILE = "sdb.log"
N = 1_000_000

# english only alphabet
letters = string.ascii_lowercase


def rand_key():
    # short keys (simulate users, ids, etc)
    klen = random.randint(5, 12)
    return "".join(random.choices(letters, k=klen))


def rand_value():
    # longer values (simulate payload / profile / message)
    vlen = random.randint(20, 80)
    return "".join(random.choices(letters + "     ", k=vlen)).strip()


def main():
    print("Generating 1,000,000 records...")
    for i in range(N):
        key = rand_key()
        value = rand_value()

        write(DB_FILE, key, value)

        # progress indicator every 10k
        if i % 10_000 == 0 and i != 0:
            print(f"{i:,} written")

    print("DONE")


if __name__ == "__main__":
    main()