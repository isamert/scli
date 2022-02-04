#!/bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

prompt_password() {
    echo -n "Password: "
    read -s GPGPASSWD
}
decrypt() {
    if [[ -f "$HOME/.local/share/scli/history.gpg" ]]; then
        test_password() {
            gpg --batch --yes --dry-run --passphrase "$GPGPASSWD" --decrypt "$HOME/.local/share/scli/history.gpg" > /dev/null
        }
        while ! test_password; do
            echo 'Bad password.'
            prompt_password
        done
        echo "Decrypting history..."
        gpg --batch --yes --passphrase "$GPGPASSWD" \
            --decrypt "$HOME/.local/share/scli/history.gpg" \
            > "$HOME/.local/share/scli/history" 
    fi
    if [[ -f "$HOME/.local/share/scli/attachments.tar.gz.gpg" ]]; then
        echo "Decrypting attachments..."
        gpg --batch --yes --passphrase "$GPGPASSWD" \
             --decrypt "$HOME/.local/share/scli/attachments.tar.gz.gpg" \
            | tar -xzf - -C "$HOME/.local/share/scli/" \
        && rm "$HOME/.local/share/scli/attachments.tar.gz.gpg" 
    fi
    if [[ -f "$HOME/.local/share/signal-cli/data.tar.gz.gpg" ]]; then
        echo "Decrypting device link..."
        gpg --batch --yes --passphrase "$GPGPASSWD" \
            --decrypt "$HOME/.local/share/signal-cli/data.tar.gz.gpg" \
            | tar -xzf - -C "$HOME/.local/share/signal-cli/" \
        && rm "$HOME/.local/share/signal-cli/data.tar.gz.gpg" 
    fi
}
encrypt() {
    if [[ -f  "$HOME/.local/share/scli/history" ]]; then
        echo "Encrypting history..."
        gpg --batch --yes --passphrase "$GPGPASSWD" \
            --symmetric "$HOME/.local/share/scli/history" \
        && rm "$HOME/.local/share/scli/history" \
        && if [[ -f "$HOME/.local/share/scli/history.bak" ]]; then
            rm "$HOME/.local/share/scli/history.bak" 
        fi

        echo "Encrypting attachments..."
        tar -czf "$HOME/.local/share/scli/attachments.tar.gz" \
            -C "$HOME/.local/share/scli" "attachments" \
        && gpg --batch --yes --passphrase "$GPGPASSWD" \
                --symmetric "$HOME/.local/share/scli/attachments.tar.gz" \
        && rm "$HOME/.local/share/scli/attachments.tar.gz" \
        && rm -r "$HOME/.local/share/scli/attachments" 

        echo "Encrypting device link..."
        tar -czf "$HOME/.local/share/signal-cli/data.tar.gz" \
            -C "$HOME/.local/share/signal-cli" "data" \
        && gpg --batch --yes --passphrase "$GPGPASSWD" \
                --symmetric "$HOME/.local/share/signal-cli/data.tar.gz" \
        && rm -r "$HOME/.local/share/signal-cli/data.tar.gz" \
        && rm -r "$HOME/.local/share/signal-cli/data" 
    fi
}
prompt_password
decrypt
trap encrypt EXIT
"${DIR}/scli"
