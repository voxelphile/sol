FROM rust

WORKDIR /usr/src/app
COPY . .

RUN mkdir -p ~/.ssh/ && echo ${ARG_SSH_KEY} >> ~/.ssh/id_rsa && chmod 400 ~/.ssh/id_rsa && echo ${ARG_GITHUB_KEY} > ~/.ssh/known_hosts&& printf "Host *\nUseKeychain yes\nAddKeysToAgent yes\nIdentityFile ~/.ssh/id_rsa" > ~/.ssh/config && eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa && rustup target add aarch64-unknown-linux-gnu && cargo build --release --bin sol --target aarch64-unknown-linux-gnu

EXPOSE 0.0.0.0:13127

CMD ["./target/release/photon"]