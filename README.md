# easy-twitch-streaming-in-linux

This is a slight repackaging of excellent work by [tiangolo](https://github.com/tiangolo) via his [Github repo https://github.com/tiangolo/nginx-rtmp-docker](https://github.com/tiangolo/nginx-rtmp-docker).

I've streamlined the process by adding a `Makefile` and `docker-compose` definition, to aid in easy specification of shared volumes, ensuring the container launches at system reboots, and exporting nginx logs for troubleshooting.

I'm sharing this as per the request of the awesome [sgtawesomesauce](https://forum.level1techs.com/u/sgtawesomesauce) and if you have any questions, come [join the fun at Level 1 Techs forums](https://forum.level1techs.com/t/anyone-stream-to-twitch-much/121565/4?u=bsodmike).

## Configuration

You will need to create the following directories

- `mkdir -p /opt/twitch/recordings`
- `mkdir -p /opt/twitch/shared/nginx`
- `chmod 777 -R /opt/twitch/recordings`

nginx logs are persisted to `/opt/twitch/shared/nginx/access.log` and `/opt/twitch/shared/nginx/error.log` respectively.

Pay attention to the ipv4 address assigned to the `docker0` interface (this is setup automatically when installing docker); this is specified in the `nginx.conf` file, and needs to match accordingly with the IP address on your system.

```
$ ifconfig

docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500                                                                          
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 0.0.0.0                                                                        
```

### Transcoding with ffmpeg

You will also want to [tweak the output resolution of the transcoded feed](https://github.com/bsodmike/easy-twitch-streaming-in-linux/blob/master/nginx.conf#L19) by editing the `-s <resolution>` option passed to `ffmepeg`.  I've used a resolution that is 720p friendly for the Acer Predator X34 display.

It is advisable to use a stream bit-rate of 2000k so as to ensure your mobile streamers have a good experience.

By default, 8 threads have been configured; if you have more cores, you can bump this up.

## How to use

* For the simplest case, just run the following in the root of this repo:

```bash
export RTMP_RECORD_PATH='/opt/twitch/recording'
export TWITCH_PUSH_URI='<Your Twitch URL>'

make build
make run
```

If you're running a firewall, say `ufw`, you'll need to allow access to port `1935` with `sudo ufw allow 1935`.  You can also setup a different `host` port by replacing it in the `docker-compose.yml` config.

## How to test with OBS Studio and VLC


* Run a container with the command above

* Open [OBS Studio](https://obsproject.com/)
* Click the "Settings" button
* Go to the "Stream" section
* In "Stream Type" select "Custom Streaming Server"
* In the "URL" enter the `rtmp://<ip_of_host>/livein` replacing `<ip_of_host>` with the IP of the host in which the container is running. For example: `rtmp://192.168.0.30/livein`
* In the "Stream key" use a "key" that will be used later in the client URL to display that specific stream. For example: `test`
* Click the "OK" button
* In the section "Sources" click de "Add" button (`+`) and select a source (for example "Display Capture") and configure it as you need
* Click the "Start Streaming" button
* Open a [VLC](http://www.videolan.org/vlc/index.html) player (it also works in Raspberry Pi using `omxplayer`)
* Click in the "Media" menu
* Click in "Open Network Stream"
* Enter the URL from above as `rtmp://<ip_of_host>/livein/` replacing `<ip_of_host>` with the IP of the host in which the container is running. For example: `rtmp://192.168.0.30/livein`
* Click "Play"
* Now VLC should start playing whatever you are transmitting from OBS Studio

## Caveats / TODO

- Limit access to the `rtmp` ingress streams.  For the timebeing, lock this down using a decent firewall.

Feel free to contribute to this repo

## Contributing

If you want to contribute, your help is very welcome.  Constructive, helpful bug reports, feature requests and the noblest of all contributions: a good, clean pull request &mdash; are most appreciated!

### How to make a clean pull request

- Create a personal fork of the project on Github.
- Clone the fork on your local machine. Your remote repo on Github is called `origin`.
- Add the original repository as a remote called `upstream`.
- If you created your fork a while ago be sure to pull upstream changes into your local repository.
- Create a new branch to work on! Branch from `dev` if it exists, else from `master`.
- Implement/fix your feature, comment your code.
- Follow the code style of the project, including indentation.
- If the project has tests run them!
- Write or adapt tests as needed.
- Add or change the documentation as needed.
- Squash your commits into a single commit with git's [interactive rebase](https://help.github.com/articles/interactive-rebase). Create a new branch if necessary.
- Push your branch to your fork on Github, the remote `origin`.
- From your fork open a pull request in the correct branch. Target the project's `dev` branch if there is one, else go for `master`!
- …
- If the maintainer requests further changes just push them to your branch. The PR will be updated automatically.
- Once the pull request is approved and merged you can pull the changes from `upstream` to your local repo and delete
your extra branch(es).

And last but not least: Always write your commit messages in the present tense. Your commit message should describe what the commit, when applied, does to the code – not what you did to the code.

## License

This project is licensed under the terms of the MIT License.