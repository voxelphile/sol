FROM rust

WORKDIR /usr/src/app
COPY . .

ADD /root/.ssh /root/.ssh

RUN rustup target add aarch64-unknown-linux-gnu
RUN cargo build --release --bin sol --target aarch64-unknown-linux-gnu

EXPOSE 0.0.0.0:13127

CMD ["./target/release/photon"]