# NCP Security

## Secret management

```mermaid
graph TD
    U[User password] --> UM{"aes(bcrypt(pw, salt))/\nmfkdf()"}
    UM --> M["key derivation key (KDK)"]
    M --> MD{"kdf(KDK, salt)"}
    MD --> DP[DB Password]
    MD --> CP[Collabora Password]
    MD --> BP[Backup Password]
    MD --> EP[Encryption key]
    MD --> OP[,,,]
```

## Resources (unsorted)

- https://systemd.io/CREDENTIALS/
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/configuring-automated-unlocking-of-encrypted-volumes-using-policy-based-decryption_security-hardening
- https://www.privex.io/articles/unlock-luks-remotely-ssh-dropbear/