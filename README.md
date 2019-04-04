# OpenGL (Mesa) in Docker

The inspiration for this build came from: https://github.com/utensils/docker-opengl/

With opengl (mesa) properly installed within the container, I could run glxinfo and glxgears. As an added bonus, this uses the llvmpip driver instead of swrast, which should be faster

I simply adapted the install to Ubuntu 18.04.

```
docker build -t caldweba/opengl-docker .
```
