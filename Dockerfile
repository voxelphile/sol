FROM rust

WORKDIR /usr/src/app
COPY . .

RUN echo "${ARG_SSH_KEY}" >> /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
RUN echo "${ARG_GITHUB_KEY}" > /root/.ssh/known_hosts

RUN rustup target add aarch64-unknown-linux-gnu
RUN cargo build --release --bin sol --target aarch64-unknown-linux-gnu

EXPOSE 0.0.0.0:13127

CMD ["./target/release/photon"]