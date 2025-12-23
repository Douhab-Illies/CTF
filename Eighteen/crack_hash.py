import hashlib
import sys

def crack_pbkdf2_sha256(hash_line, wordlist_path):
    try:
        # Décomposer le hash
        algo_info, salt, target_hash = hash_line.strip().split('$')
        _, algo, iterations = algo_info.split(':')

        iterations = int(iterations)

        print(f"[+] Hash info: algo=PBKDF2-{algo}, iterations={iterations}, salt={salt}")

        with open(wordlist_path, 'r', encoding='utf-8', errors='ignore') as f:
            for password in f:
                password = password.strip()
                test_hash = hashlib.pbkdf2_hmac(
                    algo,
                    password.encode(),
                    salt.encode(),
                    iterations
                ).hex()

                if test_hash == target_hash:
                    print(f"[✅] Mot de passe trouvé : {password}")
                    return password

        print("[❌] Mot de passe introuvable dans la wordlist.")
        return None

    except Exception as e:
        print(f"[!] Erreur : {e}")
        sys.exit(1)

# --- Configuration ---
hash_input = "pbkdf2:sha256:600000$AMtzteQIG7yAbZIa$0673ad90a0b4afb19d662336f0fce3a9edd0b7b19193717be28ce4d66c887133"
wordlist_path = "/usr/share/wordlists/rockyou.txt"  # Modifie selon ton système

# --- Lancement ---
crack_pbkdf2_sha256(hash_input, wordlist_path)
