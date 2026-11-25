resource "google_cloud_run_service" "default" {
  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/project/repo/image:1.2"
      }
    }
  }
}

resource "google_cloud_run_v2_job" "default" {
  template {
    template {
      containers {
        image = "us-docker.pkg.dev/project/repo/job:2.1"
      }
    }
  }
}

resource "google_cloud_run_v2_worker_pool" "default" {
  template {
    containers {
      image = "us-docker.pkg.dev/project/repo/worker:3.0"
    }
  }
}

resource "google_dataproc_batch" "default" {
  runtime_config {
    container_image = "us-docker.pkg.dev/project/repo/dataproc:4.0"
  }
}

resource "google_cloudbuild_trigger" "default" {
  build {
    step {
      name = "gcr.io/cloud-builders/docker:5.0.0"
    }
  }
}
