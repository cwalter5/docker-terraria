#This work if based on https://hub.docker.com/r/ryshe/terraria/
FROM ubuntu:14.04.4

MAINTAINER Chris Walter <chrisdubz@gmail.com>

# Add mono repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list

# Update and install mono and a zip utility
RUN apt-get update && apt-get install -y \
  zip \
  mono-complete && \ 
  apt-get clean

# Download and install Terraria Server (I'm assuming they don't change their naming standards too much)
# I'm also lazy and don't want to have to repackaging the zip everytime a new server comes out.
ENV TERRARIA_VERSION 1321

ADD http://terraria.org/server/terraria-server-$TERRARIA_VERSION.zip /
RUN unzip terraria-server-$TERRARIA_VERSION.zip Dedicated\ Server/Linux/* -d /temp
RUN rm terraria-server-$TERRARIA_VERSION.zip
RUN mkdir /terraria
RUN mv /temp/Dedicated\ Server/Linux/* /terraria
RUN rm -r /temp

# Allow for external data
VOLUME ["/world"]

# Set working directory to server
WORKDIR "/terraria"

# Set permissions
RUN chmod 777 TerrariaServer.exe

# run the server
ENTRYPOINT ["mono", "--server", "--gc=sgen", "-O=all", "TerrariaServer.exe", "-configpath", "/world", "-worldpath", "/world", "-logpath", "/world"]




