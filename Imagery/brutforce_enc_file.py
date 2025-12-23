#!/usr/bin/env python3
import pyAesCrypt
import tempfile, os, sys

BUFFER_SIZE = 64 * 1024  # taille usuelle
enc_file = "./web_20250806_120723.zip.aes"      # fichier chiffré par pyAesCrypt
wordlist = "/usr/share/wordlists/rockyou.txt"

def try_password(password):
    # crée un fichier temporaire pour la sortie
    fd, outpath = tempfile.mkstemp(prefix="pyaes_bf_", suffix=".out")
    os.close(fd)
    try:
        pyAesCrypt.decryptFile(enc_file, outpath, password, BUFFER_SIZE)
        # si on arrive ici, pas d'exception : possible succès
        # vérif simple : fichier non vide
        if os.path.getsize(outpath) > 0:
            return True, outpath
        else:
            # décrytp ok mais vide (rare) => considérer comme échec
            os.remove(outpath)
            return False, None
    except Exception as e:
        # mot de passe incorrect ou intégrité KO
        try:
            os.remove(outpath)
        except Exception:
            pass
        return False, None

if __name__ == "__main__":
    if not os.path.exists(enc_file):
        print("Encrypted file not found:", enc_file); sys.exit(1)
    if not os.path.exists(wordlist):
        print("Wordlist not found:", wordlist); sys.exit(1)

    with open(wordlist, "r", encoding="utf-8", errors="ignore") as f:
        for i, line in enumerate(f, 1):
            pw = line.strip()
            if not pw:
                continue
            ok, out = try_password(pw)
            #print(f"[{i}] Testing: {pw} ->", "OK" if ok else "BAD")
            if ok:
                print("Password found:", pw)
                print("Decrypted file at:", out)
                sys.exit(0)

    print("No password matched.")
