use std::{sync::Arc, f32::consts::E};

use game_common::Message;
use quinn::{Endpoint, ServerConfig};


const PRIVATE_KEY: &'static str = include_str!("../ssl/voxelphile.key");
const CERTIFICATE: &'static str = include_str!("../ssl/voxelphile.crt");

#[tokio::main]
async fn main() {
    let server_addr = "0.0.0.0:13127".parse().unwrap();

    let private_key = rustls::PrivateKey(pem::parse(PRIVATE_KEY).unwrap().contents().to_vec());
    let certificate = vec![rustls::Certificate(pem::parse(CERTIFICATE).unwrap().contents().to_vec())];

    let mut server_config = ServerConfig::with_single_cert(certificate, private_key).unwrap();

    let transport_config = Arc::get_mut(&mut server_config.transport).unwrap();
    transport_config.max_concurrent_bidi_streams(8192u32.into());
    transport_config.max_concurrent_uni_streams(8192u32.into());

    let endpoint = Endpoint::server(server_config, server_addr).unwrap();

    loop {
        while let Ok(connection) = endpoint.accept().await.unwrap().await {
            tokio::spawn(async move {
                let Ok((mut send_stream, mut recv_stream)) = connection.accept_bi().await else {
                    return;
                };
                let mut buffer = vec![0u8; 65535];
                loop {
                    if let Err(e) = send_stream.stopped().await {
                        eprintln!("{}", e);
                        return;
                    }

                    let Ok(Some(len)) = recv_stream.read(&mut buffer).await else {
                        continue;
                    };

                    let Ok(message) = Message::from_bytes(&buffer[..len]) else {
                        continue;
                    };

                    match message {
                        Message::Ping => { println!("recv ping, send pong"); send_stream.write(&Message::Pong.to_bytes()) },
                        _ => continue
                    }
                }
            });
        }
    } 
}
