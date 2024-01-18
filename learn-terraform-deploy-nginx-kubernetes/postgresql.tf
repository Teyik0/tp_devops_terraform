# PersistentVolume
resource "kubernetes_persistent_volume" "postgresdb" {
  metadata {
    name = "postgresdb-persistent-volume"
    labels = {
      type = "local"
      app  = "postgresdb"
    }
  }

  spec {
    capacity = {
      storage = "8Gi"
    }
    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/data/db"
      }
    }
  }
}

# PersistentVolumeClaim
resource "kubernetes_persistent_volume_claim" "postgresdb" {
  metadata {
    name = "db-persistent-volume-claim"
  }

  spec {
    storage_class_name = "manual"
    access_modes       = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "8Gi"
      }
    }
  }
}

# ConfigMap
resource "kubernetes_config_map" "postgresdb" {
  metadata {
    name = "db-secret-credentials"
    labels = {
      app = "postgresdb"
    }
  }

  data = {
    POSTGRES_DB       = "testDB"
    POSTGRES_USER     = "testUser"
    POSTGRES_PASSWORD = "testPassword"
  }
}
