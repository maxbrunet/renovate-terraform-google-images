# Renovate minimal reproduction: Google provider container images

Reproduction for [renovatebot/renovate#46311](https://github.com/renovatebot/renovate/pull/46311):
Renovate extracts container images pinned in Google provider Terraform resources.
[The guide to minimal reproductions](https://github.com/renovatebot/renovate/blob/main/docs/development/minimal-reproductions.md).

## Current behavior

On `renovatebot/renovate` `main`, no updates are proposed for the images in `google.tf`.
The Terraform manager only extracts images from Docker and Kubernetes provider resources.

## Expected behavior

With #46311, each image below is extracted and updated through the standard docker lookup,
like the existing Kubernetes support:

| Resource                          | Extracted path                          | Image                                         |
| --------------------------------- | --------------------------------------- | --------------------------------------------- |
| `google_cloud_run_service`        | `template.spec.containers[].image`      | `us-docker.pkg.dev/project/repo/image:1.2`    |
| `google_cloud_run_v2_job`         | `template.template.containers[].image`  | `us-docker.pkg.dev/project/repo/job:2.1`      |
| `google_cloud_run_v2_worker_pool` | `template.containers[].image`           | `us-docker.pkg.dev/project/repo/worker:3.0`   |
| `google_dataproc_batch`           | `runtime_config.container_image`        | `us-docker.pkg.dev/project/repo/dataproc:4.0` |
| `google_cloudbuild_trigger`       | `build.step[].name` (the builder image) | `gcr.io/cloud-builders/docker:5.0.0`          |

## How to verify

The `local` platform verifies this without any hosted platform.
Run from the root of this directory, inside a clone of renovatebot/renovate:

```sh
# on main, the log has no extraction for these resources:
git checkout main
pnpm install
LOG_LEVEL=debug pnpm exec node lib/renovate.ts --platform=local --dry-run=extract > main.log 2>&1
grep -cE 'google_(cloud_run|dataproc_batch|cloudbuild_trigger)' main.log

# on the feature branch, the log shows each extracted dependency:
git checkout <branch>
LOG_LEVEL=debug pnpm exec node lib/renovate.ts --platform=local --dry-run=extract > branch.log 2>&1
grep -E 'google_(cloud_run|dataproc_batch|cloudbuild_trigger)' branch.log
```

Expected: `main.log` contains no `google_*` dependency extraction;
`branch.log` logs all five resources above.

