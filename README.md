# CSI WEBDAV driver

## Workflows
* first login to docker hub (you need to be part of the mindk organisation)

### Publish automatically
```sh
publish.sh 1.0.3
```

### Deploy example to cluster
```sh
# create resources
deploy.sh c

# delete resources
deploy.sh d

# delete first, then create resources again
deploy.sh b
```

## Kubernetes

### Requirements

The folllowing feature gates and runtime config have to be enabled to deploy the driver

```
FEATURE_GATES=CSIPersistentVolume=true,MountPropagation=true
RUNTIME_CONFIG="storage.k8s.io/v1alpha1=true"
```

Mountprogpation requries support for privileged containers. So, make sure privileged containers are enabled in the cluster.

### Example local-up-cluster.sh

```
ALLOW_PRIVILEGED=true FEATURE_GATES=CSIPersistentVolume=true,MountPropagation=true RUNTIME_CONFIG="storage.k8s.io/v1alpha1=true" LOG_LEVEL=5 hack/local-up-cluster.sh
```

### Deploy

```kubectl -f deploy/kubernetes create```

### Example Nginx application
Please update the WEBDAV Server & share information in nginx.yaml file.

```kubectl -f examples/kubernetes/nginx.yaml create```

## Using CSC tool

### Build davfsplugin
```
$ make davfs
```

### Start WEBDAV driver
```
$ sudo ./_output/davfsplugin --endpoint tcp://127.0.0.1:10000 --nodeid CSINode -v=5
```

## Test
Get ```csc``` tool from https://github.com/rexray/gocsi/tree/master/csc

#### Get plugin info
```
$ csc identity plugin-info --endpoint tcp://127.0.0.1:10000
"WEBDAV"	"0.1.0"
```

#### NodePublish a volume
```
$ export WEBDAV_SERVER="Your Server IP (Ex: 10.10.10.10)"
$ export WEBDAV_SHARE="Your WEBDAV share"
$ csc node publish --endpoint tcp://127.0.0.1:10000 --target-path /mnt/davfs --attrib server=$WEBDAV_SERVER --attrib share=$WEBDAV_SHARE davfstestvol
davfstestvol
```

#### NodeUnpublish a volume
```
$ csc node unpublish --endpoint tcp://127.0.0.1:10000 --target-path /mnt/davfs davfstestvol
davfstestvol
```

#### Get NodeID
```
$ csc node get-id --endpoint tcp://127.0.0.1:10000
CSINode
```
## Running Kubernetes End To End tests on an WEBDAV Driver

First, stand up a local cluster `ALLOW_PRIVILEGED=1 hack/local-up-cluster.sh` (from your Kubernetes repo)
For Fedora/RHEL clusters, the following might be required:
  ```
  sudo chown -R $USER:$USER /var/run/kubernetes/
  sudo chown -R $USER:$USER /var/lib/kubelet
  sudo chcon -R -t svirt_sandbox_file_t /var/lib/kubelet
  ```
If you are plannig to test using your own private image, you could either install your davfs driver using your own set of YAML files, or edit the existing YAML files to use that private image.

When using the [existing set of YAML files](https://github.com/kubernetes-csi/csi-driver-davfs/tree/master/deploy/kubernetes), you would edit the [csi-attacher-davfsplugin.yaml](https://github.com/kubernetes-csi/csi-driver-davfs/blob/master/deploy/kubernetes/csi-attacher-davfsplugin.yaml#L46) and [csi-nodeplugin-davfsplugin.yaml](https://github.com/kubernetes-csi/csi-driver-davfs/blob/master/deploy/kubernetes/csi-nodeplugin-davfsplugin.yaml#L45) files to include your private image instead of the default one. After editing these files, skip to step 3 of the following steps.

If you already have a driver installed, skip to step 4 of the following steps.

1) Build the davfs driver by running `make`
2) Create WEBDAV Driver Image, where the image tag would be whatever that is required by your YAML deployment files        `docker build -t quay.io/k8scsi/davfsplugin:v1.0.0 .`
3) Install the Driver: `kubectl create -f deploy/kubernetes`
4) Build E2E test binary: `make build-tests`
5) Run E2E Tests using the following command: `./bin/tests --ginkgo.v --ginkgo.progress --kubeconfig=/var/run/kubernetes/admin.kubeconfig`


## Community, discussion, contribution, and support

Learn how to engage with the Kubernetes community on the [community page](http://kubernetes.io/community/).

You can reach the maintainers of this project at:

- [Slack channel](https://kubernetes.slack.com/messages/sig-storage)
- [Mailing list](https://groups.google.com/forum/#!forum/kubernetes-sig-storage)


### Code of conduct

Participation in the Kubernetes community is governed by the [Kubernetes Code of Conduct](code-of-conduct.md).

[owners]: https://git.k8s.io/community/contributors/guide/owners.md
[Creative Commons 4.0]: https://git.k8s.io/website/LICENSE
