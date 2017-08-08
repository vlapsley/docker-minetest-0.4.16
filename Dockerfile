FROM lsiobase/alpine:3.6

# set version label
LABEL maintainer="vaughan.lapsley@gmail.com"

# environment variables
ENV HOME="/config" \
MINETEST_SUBGAME_PATH="/config/.minetest/games"

# build variables
ARG LDFLAGS="-lintl"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	bzip2-dev \
	cmake \
	curl-dev \
	doxygen \
	g++ \
	gcc \
	gettext-dev \
	git \
	gmp-dev \
	hiredis-dev \
	icu-dev \
	irrlicht-dev \
	libjpeg-turbo-dev \
	libogg-dev \
	libpng-dev \
	libressl-dev \
	libtool \
	libvorbis-dev \
	luajit-dev \
	make \
	mesa-dev \
	openal-soft-dev \
	python-dev \
	sqlite-dev && \

apk add --no-cache --virtual=build-dependencies \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	leveldb-dev && \

# install runtime packages
 apk add --no-cache \
	curl \
	gmp \
	hiredis \
	libgcc \
	libintl \
	libstdc++ \
	luajit \
	lua-socket \
	sqlite \
	sqlite-libs && \

apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	leveldb && \

# compile spatialindex
 git clone https://github.com/libspatialindex/libspatialindex /tmp/spatialindex && \
 cd /tmp/spatialindex && \
 cmake . \
	-DCMAKE_INSTALL_PREFIX=/usr && \
 make && \
 make install && \

# prep for minetest compile
 mkdir -p /tmp/minetest && \
 
# download and compile minetestserver 0.4.16 from git
 curl -L -O https://github.com/minetest/minetest/archive/0.4.16.tar.gz && \
 tar -xf 0.4.16.tar.gz && cp -r minetest-0.4.16/* /tmp/minetest/ && \
 rm -rf 0.4.16.tar.gz minetest-0.4.16 && \
 cp /tmp/minetest/minetest.conf.example /defaults/minetest.conf && \
 cd /tmp/minetest && \
 cmake . \
	-DBUILD_CLIENT=0 \
	-DBUILD_SERVER=1 \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCUSTOM_BINDIR=/usr/bin \
	-DCUSTOM_DOCDIR="/usr/share/doc/minetest" \
	-DCUSTOM_SHAREDIR="/usr/share/minetest" \
	-DENABLE_CURL=1 \
	-DENABLE_LEVELDB=1 \
	-DENABLE_LUAJIT=1 \
	-DENABLE_REDIS=1 \
	-DENABLE_SOUND=0 \
	-DENABLE_SYSTEM_GMP=1 \
	-DRUN_IN_PLACE=0 && \
 make && \
 make install && \

# copy games to temporary folder
 mkdir -p \
	/defaults/games/minetest && \
 cp -pr  /usr/share/minetest/games/* /defaults/games/ && \

# download and extract minetest 0.4.16 stable game from git
 curl -O -L https://github.com/minetest/minetest_game/archive/0.4.16.tar.gz && \
 tar -xf 0.4.16.tar.gz && cp -r minetest_game-0.4.16/* /defaults/games/minetest/ && \
 rm -rf 0.4.16.tar.gz minetest_game-0.4.16 && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root /

# ports and volumes
EXPOSE 30000/udp
VOLUME /config/.minetest
