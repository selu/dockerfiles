Latest development version of Gimp compiled from [gimp.org](http://download.gimp.org/mirror/pub/gimp/v2.9/).
Current version is 2.9.2

Based on Ubuntu Wily

## Usage

Local X11 server
> `docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix selu/gimp-devel`

Remote SSH into docker host, low isolation

> `docker run -it --rm --net=host -e DISPLAY=$DISPLAY -v $HOME:/hosthome:ro -e XAUTHORITY=/hosthome/.Xauthority selu/gimp-devel`

You can also install sshd onto the image and ssh directly into it.

