[linuxserverurl]: https://linuxserver.io
[appurl]: http://www.minetest.net/
[hub]: https://hub.docker.com/r/linuxserver/minetest/

This image is based on the [LinuxServer.io][linuxserverurl] build at [DockerHub][hub]. Instead of running a server with the development version of Minetest, this server runs stable version 0.4.16

# vlapsley/minetestserver-0.4.16
[Minetest][appurl] (server) is a near-infinite-world block sandbox game and a game engine, inspired by InfiniMiner, Minecraft, and the like.

[![minetest](https://raw.githubusercontent.com/linuxserver/beta-templates/master/lsiodev/img/minetest-icon.png)][appurl]

## Usage

```
docker create \
  --name=minetest \
  -v <path to data>:/config/.minetest \
  -e PGID=<gid> -e PUID=<uid>  \
  -p 30000:30000/udp
  vlapsley/minetestserver-0.4.16
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`

* `-p 30000/udp` - the port(s)
* `-v /config/.minetest` - where minetest stores config files and maps etc.
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it minetest /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

You can find the world maps, mods folder and config files in /config/.minetest.

## Info

* Shell access whilst the container is running: `docker exec -it minetest /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f minetest`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' minetest`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' vlapsley/minetestserver-0.4.16`

## Versions

+ **08.08.2017:** Change Minetest from dev to stable 0.4.16 version.
+ **26.05.2017:** Rebase to alpine 3.6.
+ **14.02.2017:** Rebase to alpine 3.5.
+ **25.11.2016:** Rebase to alpine linux, move to main repo.
+ **27.02.2016:** Bump to latest version.
+ **19.02.2016:** Change port to UDP, thanks to slashopt for pointing this out.
+ **15.02.2016:** Make minetest app a service.
+ **01-02-2016:** Add lua-socket dependency.
+ **06.11.2015:** Initial Release. 
