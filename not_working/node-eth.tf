resource "kubernetes_stateful_set" "geth_mainnet_full" {
  metadata {
    name = "geth-mainnet-full"
  }

  spec {
    service_name = "geth-mainnet-full"
    replicas     = 1

    selector {
      match_labels = {
        app = "geth-mainnet-full"
      }
    }

    template {
      metadata {
        labels = {
          app = "geth-mainnet-full"
        }
      }

      spec {
        container {
          name  = "geth-mainnet-full"
          image = "ethereum/client-go:v1.9.23"

          args = [
            "--http",
            "--http.addr=0.0.0.0",
            "--http.vhosts=geth-mainnet-full",
            "--http.api=eth,net,web3,txpool",
            "--ws",
            "--ws.addr=0.0.0.0",
            "--datadir=/data",
          ]

          ports {
            port {
              container_port = 8545
              name           = "gethrpc"
            }
            port {

              container_port = 30303
              name           = "gethdiscovery"
            }

          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          resources {
            limits = {
              memory = "12000Mi"
            }
            requests = {
              memory = "10000Mi"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "do-block-storage"

        resources {
          requests = {
            storage = "1000Gi"
          }
        }
      }
    }
  }
}
