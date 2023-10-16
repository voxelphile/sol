FROM rust

WORKDIR /usr/src/app
COPY . .

RUN mkdir -p ~/.ssh/
RUN echo "${ARG_SSH_KEY}" >> ~/.ssh/id_rsa
RUN chmod 400 ~/.ssh/id_rsa
RUN echo "${ARG_GITHUB_KEY}" > ~/.ssh/known_hosts
RUN printf "Host *\nUseKeychain yes\nAddKeysToAgent yes\nIdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
RUN eval $(ssh-agent)
RUN ssh-add -K ~/.ssh/id_rsa

RUN rustup target add aarch64-unknown-linux-gnu
RUN cargo build --release --bin sol --target aarch64-unknown-linux-gnu

EXPOSE 0.0.0.0:13127

CMD ["./target/release/photon"]