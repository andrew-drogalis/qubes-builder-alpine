# qubes-builder-alpine
Fork of Avakael's repo: https://lab.ilot.io/ayakael/qubes-builder-alpine

## Description

This repository contains an implementation of a template builder for Alpine
Linux for usage by qubes-builder. Packages are pulled from a community repo
and packaged in an RPM that is installable by QubesOS.

### Current state
Alpine Linux as a QubesOS template is still a work and progress. It is highly encouraged to make bug reports.

#### The yet-to-be-implemented list 
Thus the following use cases are still not supported / tested:
 * QubesOS r4.2
 * Service VMs (sys-net, sys-usb, sys-firewall)
 * Firewall (not tested)
 * `qubes-builder` hooks (thus no `dom0` template RPM yet, see [here](https://gitlab.alpinelinux.org/ayakael/qubes-builder-alpine) for progress)
 * `apk` proxying from within template (thus you must allow internet access to template to install packages)
 * `qubes-vm-kernel-support` Not adapted for use on Alpine yet, due to it providing a Dracut module. In most cases, it is not necessary as Qubes provides the kernel. 
   This package is only neccessary when VM uses its own kernel, thus a hook is added to Dracut to generate the initrd for use within qubes.

#### Issues, recommendations and proposals
**To report an issue or share a recommendation**

Go [here](https://gitlab.alpinelinux.org/ayakael/qubes-builder-alpine/-/issues)

**To make a merge request**
 * Fork the repo from Alpine's GitLab [here](https://gitlab.alpinelinux.org/ayakael/qubes-builder-alpine)
 * Clone your fork locally. (`git clone $repo`)
 * Make a branch with a descriptive name (`git checkout -b $descriptivename`)
 * Make the changes you want to see in the world, commit, and push to the GitLab's remote repo
 * Request a merge [here](https://gitlab.alpinelinux.org/ayakael/qubes-builder-alpine/-/merge_requests)
