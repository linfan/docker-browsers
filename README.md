# docker-browsers
Docker images for Chrome and Firefox browser with various versions and alauda.cn support 

There is also a `create-browser.sh` script for helping user create any browser version on `alauda.cn`, which will directly use the images I have submitted into alauda cloud.

To use this script you have to get your API token from `alauda.cn`, and set it to environment variable ALAUDA_TOKEN.

```
export ALAUDA_TOKEN=<your-alauda-api-token>
```

Then the script can be use like this:

```
./create-browser.sh <Browser> <Version>
```

E.g. `./create-browser.sh firefox 38` will create a Firefox v38 instance on alauda.cn and return the VNC address of this instance. The VNC connection password is currently always `alauda` which is hard coded in Dockerfiles.

====
> It's a brand-new repo base on the idea of templating Dockerfiles. <br>
> Some commits of how this project was built up already got lost in the old repo. <br>
> Anyway, those are all just trivials : ).
