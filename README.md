# docker-browsers
---

Docker images for Chrome and Firefox browser with various versions support.  
Check the `BrowserDockerfileGenerator/generator.sh` script for more details.

There is also a `create-browser-instance.sh` script for helping user create any browser version on `alauda.cn`, which will directly use the images I have submitted into alauda cloud.
To use this script you have to get your API token from `alauda.cn`, and set it to environment variable `ALAUDA_TOKEN`.

```
export ALAUDA_TOKEN=<your-alauda-api-token>
./create-browser-instance.sh <Browser> <Version>
```

E.g. `./create-browser.sh firefox 38` will create a Firefox v38 instance on alauda.cn and return the VNC address of this instance. The VNC connection password is currently always `alauda` which is hard coded in Dockerfiles.

> PS1: Some old browser versions are removed from repo, but they can be found in commit history, in case u need.
> PS2: Alauda.cn public cloud service is no longer available any more, just use the image directly.
