# bradyverse

## run your own local brady

```sh
docker run --rm -it -p 25565:25565 ghcr.io/pgmffenthusiasts/bradyverse-backend:latest
```

if you want to persist the data, you should give something like this a try:

```sh
docker run --rm -it -p 25565:25565 -v ./data:/server ghcr.io/pgmffenthusiasts/bradyverse-backend:latest
```

> [!CAUTION]
> Don't delete `start.sh` in the data folder, as this will cause the server to be re-copied from the template.

## dump mode

to dump all server files to a mounted volume without starting the server:

```sh
docker run --rm -v ./data:/server ghcr.io/pgmffenthusiasts/bradyverse-backend:latest dump
```

this is useful for inspecting or manually modifying the server files.

## building details

simply use `build.sh` minding the dependencies listed in there. it will load a docker image tagged `bradyverse-backend:latest`.

## running details

you gotta use environment variables, for the most part. the proxy isn't included in this repository, but i'll write about it
in the future (maybe).

```env
# standalone means it does NOT need bungeecord/velocity to connect
STANDALONE=true

# not optional
BRADY_SERVER=primary

# this is for the share plugin
DATABASE_URI=127.0.0.1:5432/stats
DATABASE_USER=postgres
DATABASE_PASS=secret

# for updating discord stuff (optional)
BRADY_BOT_TOKEN=
BRADY_BOT_BILLBOARD_CHANNEL=
# this be a NATS server for discord & status push
BRADY_NATS=

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

there is also something i'm dubbing the "latemerge" method (and only because i don't really wanna build private images)
where if you mount a folder to `/merge` it'll merge that into the server directory every start AFTER TEMPLATING.

have fun with that ig!
