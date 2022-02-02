#!/bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

echo -n "Password: "
read -s GPGPASSWD

decrypt() {
    if [[ -f "$HOME/.local/share/scli/history.gpg" ]]; then
        gpg --batch --yes --passphrase "$GPGPASSWD" --decrypt "$HOME/.local/share/scli/history.gpg" > \
            "$HOME/.local/share/scli/history" 
    fi
    if [[ -f "$HOME/.local/share/scli/attachments.gpg" ]]; then
        gpg --batch --yes --passphrase "$GPGPASSWD" --decrypt "$HOME/.local/share/scli/attachments.tar.gz.gpg" \
            | tar -xzf -
    fi
}
encrypt() {
    echo "Encrypting history:"
    if [[ -f  "$HOME/.local/share/scli/history" ]]; then
        gpg --batch --yes --passphrase "$GPGPASSWD" -c "$HOME/.local/share/scli/history" && \
            rm "$HOME/.local/share/scli/history" && \
            rm "$HOME/.local/share/scli/history.bak"
        tar -cz "$HOME/.local/share/scli/attachments" \
            | gpg --batch --yes --passphrase "$GPGPASSWD" -c \
                -o "$HOME/.local/share/scli/attachments.tar.gz.gpg" && \
            rm -r "$HOME/.local/share/scli/attachments" 
    fi
}
trap encrypt EXIT
decrypt
"${DIR}/scli"
