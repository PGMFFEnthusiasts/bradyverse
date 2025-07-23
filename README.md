# bradyverse

## run your own local brady

```sh
docker run --rm -it -p 25565:25565 ghcr.io/pgmffenthusiasts/bradyverse-backend:standalone
```

if you want to persist the data, you should give something like this a try:

```sh
docker run --rm -it -p 25565:25565 -v ./data:/server ghcr.io/pgmffenthusiasts/bradyverse-backend:standalone
```

> [!CAUTION]
> Don't delete `start.sh` in the data folder, as this will cause the server to be re-copied from the template.

## building details

simply use `build.sh` minding the dependencies listed in there. it will load a docker image tagged `bradyverse-backend:latest`.

if you set the environment variable `STANDALONE=true` then it will not enable any bungeecord/velocity configuration so you can
play it without using a proxy.

## running details

you gotta use environment variables, for the most part. the proxy isn't includeed in this repository, but i'll write about it
in the future (maybe).

```env
# for updating discord stuff (optional)
BRADY_BOT_TOKEN=
BRADY_BOT_BILLBOARD_CHANNEL=
# this be a NATS server for discord & status push
BRADY_NATS=

# not optional
BRADY_SERVER=primary

# if using the metro (optional)
METRONOME_WEBHOOK=
```

to configure permissions, you'll want to consult the [Luckperms Wiki](https://luckperms.net/wiki/Configuration#environment-variables).

after building, you can pretty much run it as-is (and join assuming you are either using `STANDALONE=true` or are connecting through Velocity):

```sh
docker run --rm -it -p 25565:25565 bradyverse-backend:latest
```

## private plugins

you can create a `private` skeleton in the `skeletons` directory and the build will merge your private into the final build.
check the `out` directory to verify the correctness of your actions.
