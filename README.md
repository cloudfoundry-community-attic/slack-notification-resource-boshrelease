BOSH Release for slack-notification-resource
============================================

This BOSH release packages @Nopik's [slack-notification-resource](https://github.com/Nopik/slack-notification-resource) for Concourse, to make it simple to include the additional Concourse resource in your BOSH deployed Concourse system.

Final releases are automatically created based on any changes to the upstream slack-notification-resource

See the build pipeline http://54.82.85.58:8080/pipelines/slack-notification-resource-boshrelease for status.

Final releases are available on https://bosh.io/releases as well as this project's own [GitHub releases](https://github.com/cloudfoundry-community/slack-notification-resource-boshrelease/releases).

Installation
------------

To use this bosh release, first upload it to the BOSH/bosh-lite that is running Concourse:

```
bosh upload release https://bosh.io/d/github.com/cloudfoundry-community/slack-notification-resource-boshrelease
```

Next, update your Concourse deployment manifest to add the resource.

Add the `slack-notification-resource` release to the list:

```yaml
releases:
  - name: concourse
    version: latest
  - name: garden-linux
    version: latest
  - name: slack-notification-resource
    version: latest
```

Into the `worker` job, add the `{release: slack-notification-resource, name: just_install_packages}` job template that will install the package:

```yaml
jobs:
- name: worker
  templates:
    ...
    - {release: slack-notification-resource, name: just_install_packages}
```

And `bosh deploy` your Concourse manifest.

Setup pipeline in Concourse
---------------------------

```
fly -t bosh-lite c -c pipeline.yml --vars-from credentials.yml slack-notification-resource-boshrelease
```
